#!/bin/bash

currentUser=`whoami`
if [ $currentUser != "root" ]; then echo "Efetue a criação através do usuário: 'root'"; exit 1; fi

ip_nfs='192.168.1.106'
ip_network_share='192.168.1.0/24'
ip_worker="192.168.1.107"

title(){ echo -e "\n:: $1 ::\n"; }
err(){ if [ $1 -gt 0 ]; then exit 1; fi; }

remove_api(){ docker service rm toshiro-api-product; }
remove_db(){ docker service rm toshiro-database-product; }
remove_proxy(){ docker rm -v proxy-app-product; }
remove_image_api(){ docker rmi toshiro-api -f; }

remove_service(){
    title "Removendo serviços - containes e volumes"
    docker service rm $(docker service ls -q);
    sleep 1
    docker rm $(docker ps -aq) -f && docker rmi toshiro-api -f;
    rm -rf /var/nfs-share/api-prod/*
    rm -rf /var/nfs-share/db-prod/*
    sleep 3
    docker volume rm $(docker volume ls -q) -f;
    sleep 2
}

create_clusters(){
    userhost="tchelo@${ip_worker}"

    title(){ echo -e "\n :: $1 ::\n"; }
    err(){ if [[ $1 > 0 ]]; then exit 1; fi; }

    title "Removendo clusters"
    rm_=`ssh $userhost  "docker swarm leave --force"`
    rm_=`docker swarm leave --force`

    title "Criando manager"
    manager=`docker swarm init`
    err $?

    title "Criando worker"
    token_worker=`docker swarm join-token worker`
    token_worker=`echo $token_worker | sed 's/To add a worker to this swarm, run the following command: //'`
    ssh $userhost "$token_worker"
    err $?

    title "Sucesso na criação dos clusters."
}

generate_image_api(){
    title "Criando imagem api-rest-product"
    #cd ../api;
    cd /home/tchelo/iac/api

    docker build . --tag $1
    #npm run tsc;
    #mkdir copy-docker;
    #cp -r dist package*.json copy-docker/    
    #docker build . --tag $1
    #rm -rf copy-docker
}

container_proxy(){
    image_name="proxy-product"

    #cd ../proxy;
    cd /home/tchelo/iac/proxy

    title "Criando imagem proxy nginx"
    docker build --tag $image_name -f ../proxy/Dockerfile .
    err $?
    title "Criando container proxy"
    docker run --name proxy-app-product -p 4500:4500 -dit $image_name
    err $?
}

share(){
    title "Criando compartilhamento: $1";
    if ! [ -d $1 ]; then mkdir $1 -p; fi
    echo "$1 ${2}(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
    exportfs -ar
    err $?
}

opt_mount(){
   echo 'type=volume,src='$1',dst='$2',volume-driver=local,volume-opt=type=nfs,volume-opt=device=:'$3',"volume-opt=o=addr='$4',vers=4,rw"'
}

service_base(){    
    title "Criando serviço $1"
    local envs=""
    if [ $# -gt 6 ]; then envs='-e POSTGRES_DB=toshiro_db  -e POSTGRES_PASSWORD=toshiro'; fi
    docker service create \
    --mount $3 --name $1 --replicas $2 -p $4 $envs $6 $5;
    err $?
}

service_db(){
    
    name_image=postgres:14.5-alpine
    #name_image=postgres

    src_vol=db-product
    dst_vol=/var/lib/postgresql
    path_nfs=/var/nfs-share/db-prod
    envs_image="db"
    detach_tty="-t"
    name_service=toshiro-database-product
    replicas=1
    port_service="5432:5432"

    echo "# Arquivo de configuração NFS" > /etc/exports
    share $path_nfs $ip_network_share
    opt_vol=`opt_mount $src_vol $dst_vol $path_nfs $ip_nfs`
    service_base $name_service $replicas $opt_vol $port_service $name_image $detach_tty $envs_image
}

service_api(){
    sleep 2
    name_image=toshiro-api
    generate_image_api $name_image

    src_vol="api-product"
    dst_vol="/home/app"
    path_nfs="/var/nfs-share/api-prod"
    envs_image=""
    detach_tty="-dt"
    name_service=toshiro-api-product
    replicas=2
    port_service="3000:3000"

    share $path_nfs $ip_network_share
    opt_vol=`opt_mount $src_vol $dst_vol $path_nfs $ip_nfs`
    service_base $name_service $replicas $opt_vol $port_service $name_image $detach_tty
}

service_all(){
    service_db
    service_api
    container_proxy
}

clear;
while :
do
echo -e "::::::::::::::::::::::::\n
    1) Serviços (database, api) e proxy;
    2) Serviço database;
    3) Serviço api;
    4) Container proxy;
    5) Remove serviços e containers;
    6) Sair;
    "
    read -p  "Informe uma opção: " option
    case $option in
    1)
        remove_service
        service_all 
        ;;
    2) 
        remove_db
        service_db 
        ;;
    3)
        remove_api
        service_api 
        ;;
    4)
        remove_proxy
        container_proxy 
        ;;
    5)
        remove_service 
        ;;
    6) 
        exit 
        ;;
    *) 
        echo Opção inválida 
        ;;

    esac;
done


currentUser=`whoami`
if [ $currentUser != "root" ]; then echo "Efetue a instalação através do usuário: 'root'"; exit 1; fi

testerror(){
    if [ $1 -gt 0 ]; then exit 1; fi
}

generate_image_api(){
    echo -e "\n\nCriando imagem api-rest-product\n"
    cd ../api;
    npm run tsc;
    mkdir copy-docker;
    cp -r dist package*.json copy-docker/
    
    docker build . --tag $1
    rm -rf copy-docker
}

generate_image_proxy(){
    image_name="proxy-product:toshi"
    cd ../proxy;

    echo -e "\n:: Criando imagem proxy nginx ::\n"
    docker build --tag $image_name -f ../proxy/Dockerfile .
    testerror $?
    docker run --name proxy-app-product -p 4500:4500 -dit $image_name
    testerror $?   
}

share(){
    echo -e "\n:: Criando compartilhamento: $1 ::\n";
    if ! [ -d $1 ]; then mkdir $1; fi
    echo "$1 ${2}(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
    exportfs -ar
    testerror $?
}

opt_mount(){
   echo 'type=volume,src='$1',dst='$2',volume-driver=local,volume-opt=type=nfs,volume-opt=device=:'$3',"volume-opt=o=addr='$4',vers=4,rw"'
}

service_base(){    
    echo -e "\n:: Criando serviço $1 ::\n"
    local envs=""
    if [ $# -gt 5 ]; then envs='-e POSTGRES_DB=toshiro_db  -e POSTGRES_PASSWORD=toshiro'; fi
    docker service create \
    --mount $3 --name $1 --replicas $2 -p $4 $envs -dt $5;
    testerror $?
}

reinstall(){
    echo "\n:: Removendo serviços - containes e volumes ::\n"
    docker service rm $(docker service ls -q);    
    sleep 1
    docker rm $(docker ps -aq) -f && docker rmi toshiro-api -f;    
    sleep 3
    docker volume rm $(docker volume ls -q) -f;
    sleep 2
    #docker service ls && docker ps -a && docker volume ls;
}

reinstall
exit 1;

ip_nfs='192.168.1.105'
ip_network_share='192.168.1.0/24'

name_image=postgres:14.5-alpine
#name_image=postgres

src_vol=db-product
dst_vol=/var/lib/postgresql
path_nfs=/var/nfs-share/db-prod
envs_image="db"
name_service=toshiro-database-product
replicas=1
port_service="5432:5432"

echo "# Arquivo de configuração NFS" > /etc/exports
share $path_nfs $ip_network_share
opt_vol=`opt_mount $src_vol $dst_vol $path_nfs $ip_nfs`
service_base $name_service $replicas $opt_vol $port_service $name_image $envs_image

sleep 2
name_image=toshiro-api
generate_image_api $name_image

src_vol="api-product"
dst_vol="/home/app"
path_nfs="/var/nfs-share/api-prod"
envs_image=""
name_service=toshiro-api-product
replicas=3
port_service="3000:3000"

share $path_nfs $ip_network_share
opt_vol=`opt_mount $src_vol $dst_vol $path_nfs $ip_nfs`
service_base $name_service $replicas $opt_vol $port_service $name_image

generate_image_proxy

echo -e "\nPastas compartilhadas\n"
showmount -e

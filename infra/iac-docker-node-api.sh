
create_service(){
    echo -e "Criando serviço app-api\n"
    docker service create \
    --mount 'type=volume,src=app-api,dst=/app,volume-driver=local,volume-opt=type=nfs,volume-opt=device=:/var/nfs-api-product,"volume-opt=o=addr=192.168.1.107"' \
    --name toshiro-api-product --replicas 4 -p 3000:3000 -dt node:lts-alpine3.16;

    echo -e "Criando serviço database\n"
    docker service create \
    --mount 'type=volume,src=database-product,dst=/var/lib/postgresql/data,volume-driver=local,volume-opt=type=nfs,volume-opt=device=:/var/nfs-database-product,"volume-opt=o=addr=192.168.1.107"' \
    --name toshiro-database-api --replicas 4 -p 5432:5432 -e POSTGRES_DB=toshiro_db -e POSGRES_PASSWORD=toshiro -dt postgres:14.5-alpine;
    echo -e "\nServiços criados com sucesso\n\n";
}

create_cluster(){
    echo "Inicializando swarm - Máquina principal"
    docker swarm init;
    echo "ok";
}


create_image_api(){
    echo -e "Criando imagem\n"
    cd ../api;
    npm run tsc;
    mkdir copy-docker;
    cp -r dist package*.json copy-docker/
    echo -e "Removendo se existir o container toshiro-api-product"
    
    docker rm -f toshiro-api-product
    docker build . --tag toshiro-api
    rm -rf copy-docker

    echo -e "\nCriando container de toshiro-api-product\n"
    docker run --name toshiro-api-product -p 3000:3000 -dt toshiro-api

}

create_image_api
#create_cluster
#create_service



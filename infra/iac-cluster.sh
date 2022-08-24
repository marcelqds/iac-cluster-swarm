
userhost='tchelo@192.168.1.106'

title(){ echo -e "\n :: $1 ::\n"; }
err(){ if [[ $1 > 0 ]]; then exit 1; fi; }

create_clusters(){

    title "Criando manager"
    ssh $userhost "docker swarm init"
    err $?

    title "Criando worker"
    token_worker=`ssh $userhost "docker swarm join-token worker"`
    token_worker=`echo $token_worker | sed 's/To add a worker to this swarm, run the following command: //'`
    $token_worker
    err $?
    #title ""
}

remove_clusters(){
    title "Removendo clusters"
    rm_=`ssh $userhost  "docker swarm leave --force"`
    rm_=`docker swarm leave --force`
}

copy_files(){
    cd ../api
    npm install
    npm run tsc
    rm -rf node_modules;

    echo -e "\n:: Copiando arquivos ::\n"
    ssh $userhost "rm -rf /home/tchelo/iac/*"
    scp -r ../* $userhost:~/iac/
    echo -e "\n:: Arquivos copiados com sucesso ::\n"

    sleep 1;

}

while :
do
    echo -e "\n::::::::::::::::::::::::::::::::::::::\n        
    1) Criar Clusters;
    2) Enviar arquivos para manager;
    3) Serviços e containers;
    4) Remover Clusters;
    5) Sair.
    "
   read -p  "Informe uma opção: " option
    case $option in
    1) 
        remove_clusters
        create_clusters ;;
    2)
        copy_files ;;
    
    3)
        ssh root@192.168.1.106 "/home/tchelo/iac/infra/iac-infrastructure.sh" ;;
    4) 
        remove_clusters ;;
    5) 
        exit ;;
    *)
        echo Opção inválida ;;

    esac;
    sleep 1
#   clear
done


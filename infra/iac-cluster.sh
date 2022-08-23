
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
    title "Fim"

}

remove_clusters(){
    title "Removendo clusters"
    rm_=`ssh $userhost  "docker swarm leave --force"`
    rm_=`docker swarm leave --force`
}

while :
do
    echo -e "\n::::::::::::::::::\n        
    1) Criar Clusters;
    2) Remover Clusters;
    3) exit.
    "
   read -p  "Informe uma opção: " option
   case $option in
   1) 
        remove_clusters
        create_clusters 
        exit
        ;;
   2) 
        remove_clusters
        exit 1; 
        ;;
   3) exit;;
   *) echo Opção inválida;;
   esac;
   sleep 1
   clear
done


## Criando container db
```sh
    docker run --name db-toshiro 
```

## Criando container web-server
```sh
    docker run --name web-server-toshiro -dt -p 80:80 --mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7
```

## Criando cluster Manager com `docker swarm`
Após executar o comando abaixo, ele gerará uma linha de comando com token que será utilizado em outros computadores que serão worker, que serão gerenciadas por esse cluster Manager.
```sh
    docker swarm init 
```

## Criando cluster Worker

```sh
    docker swarm join --token `token gerado ao criar cluster manager` `ip_cluster_manager`:2377
```

Caso você precise adicionar novos cluster no futuro, você pode obter o token, através do comando abaixo, setando worker, ou manager:
```sh
    docker swarm join-token `worker|manager`
```

## Listando os clusters de um cluster manager.
Só é possível listar através do cluster gerenciador (manager)
```sh
    docker node ls
```

## Criando serviço de container no cluster, no exemplos criar um servidor web
```sh
    docker service create --name web-teste --replicas 6 -dt -p 80:80 php-apache
```

## Replicando volume
```sh
    
```

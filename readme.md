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

## Modelo tabela `product`
```SQL
    CREATE TABLE IF NOT EXISTS product(
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
        brand varchar(60) not null, 
        name varchar(50) not null, 
        price real, 
        status boolean DEFAULT true, 
        created_at timestamp DEFAULT CURRENT_TIMESTAMP, 
        UNIQUE(brand, name)
    );
```


## Fazendo Inserção na tabela produto através do protocolo http via curl.
```sh
    curl -H 'Content-Type: application/json' -d'{"brand": "Pilão","name":"Amoroso","price":6.80}' -X POST http://localhost:3000/product/
```


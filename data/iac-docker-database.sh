echo "Criando container banco de dados"
docker run --name toshiro-postgres -p 5432:5432 -e POSTGRES_DB=toshiro_db -e POSTGRES_PASSWORD=toshiro -dit postgres; 

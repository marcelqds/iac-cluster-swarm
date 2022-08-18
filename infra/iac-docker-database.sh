echo "Criando container banco de dados..."
docker rm -f toshiro-db;
docker run --name toshiro-db -p 5432:5432 -e POSTGRES_DB=toshiro_db -e POSTGRES_PASSWORD=toshiro -dit postgres; 
echo "OK"

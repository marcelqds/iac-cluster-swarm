iprequest='192.168.1.106'
proxy_port=4500
base_url=http://$iprequest:$proxy_port

ins(){
    echo -e "Insert: $1-$2"
    inser=`curl -f -H "Content-Type: application/json" -d "{\"brand\":\"$1\", \"name\":\"$2\", \"price\" : \"$3\" }" -X POST $base_url/product`
    if [ $? -eq 0 ]; then echo -e"\n$inser\n"; sleep 5; fi;
}

insert_prod(){
    echo -e "\n:: Inserção de Produto ::\n"
    sleep 2;
    ins 'Dá Rocinha' 'Café Tilzão1' '8.50'
    ins 'Dá Rocinha' 'Café Tilzão2' '8.10'
    ins 'Dá Rocinha' 'Café Tilzão3' '8.30'
    ins 'Dá Rocinha' 'Café Tilzão4' '8.40'
    ins 'Dá Rocinha' 'Café Tilzão5' '8.80'
    ins 'Dá Rocinha' 'Café Tilzão6' '10.50'
    echo -e "\n:: Finalização de inserção ::\n"
}

hasInsert=0
while :
do
    echo -e "  http://$iprequest:$proxy_port\n"
    teste=`curl -f "http://$iprequest:$proxy_port/product"`
    if [ $? -eq 0 ]; then
        echo "\n$teste\n";        
        if [ $hasInsert == 0 ]; then
            hasInsert=1
            insert_prod;
        fi
    fi
    sleep 3
    clear
done

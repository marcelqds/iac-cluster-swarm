iprequest='192.168.1.106'

ins(){
    echo "Length: $#"
    echo -e "$1, $2, $3, $4\n"
    exit;
    inser=`curl -f -H "Content-Type: application/json" -d '{"brand":"'$1'", "name":"'$2'", "price" : "'$3'" }' -X POST http://$iprequest:4500/product`
    if [ $? -eq 0 ]; then echo -e"\n$inser\n"; sleep 5; fi;
}

insert_prod(){
    echo -e "\n:: Inserção de Produto ::\n"
    sleep 5;
    ins 'Dá Rocinha' 'Café Tilzão1' '8.50'
    ins 'Dá Rocinha' 'Café Tilzão2' '8.10'
    ins 'Dá Rocinha' 'Café Tilzão3' '8.30'
    ins 'Dá Rocinha' 'Café Tilzão4' '8.40'
    ins 'Dá Rocinha' 'Café Tilzão5' '8.80'
    ins 'Dá Rocinha' 'Café Tilzão6' '10.50'
}

isTrue=0
hasInsert=0
while [ $isTrue == 0 ]
do
    echo -e "  http://192.168.1.106:4500\n"
    teste=`curl -f "http://$iprequest:4500/product"`
    if [ $? -eq 0 ]; then
        echo "\n$teste\n"; 
        
        if [$hasInsert == 0 ]; then
            hasInsert=1
            insert_prod;
        fi

    fi
    sleep 2
    clear
done

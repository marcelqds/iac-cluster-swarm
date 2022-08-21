isTrue=1
while [ $isTrue != 0 ]
do
    echo -e "  http://192.168.1.105:4500\n"
    teste=`curl -f http://192.168.1.105:4500/product`
    if [ $? -eq 0 ]; then isTrue=0; echo $teste; fi
    sleep 2
    clear
done


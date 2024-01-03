#!/bin/bash

for X in $(curl -qs 'https://www.allampapir.hu/api/network_rate/m/get_prices/BABA' | jq -r '.data.data[].name'); do
    
NAME=$(echo $X | tr \/ _ )

if [ ! -f BABA/${NAME}.html ]; then
    echo $NAME does not exist... let me create it
    cat quote_template.html >> BABA/${NAME}.html
fi

DATE=$(date +%F)
INTEREST=$(curl -qs 'https://www.allampapir.hu/api/network_rate/m/get_prices/BABA'  | jq -r ".data.data[]|select(.name == \"${X}\") | .accruedInterest" | tr \, \.)
QUOTE=$( echo "scale = 6 ; 1+$INTEREST/100" | bc -l)
echo "<tr><td>$DATE</td><td>$QUOTE</td></tr>" >> BABA/${NAME}.html
done


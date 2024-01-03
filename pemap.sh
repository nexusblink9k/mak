#!/bin/bash

for X in $(curl -qs 'https://www.allampapir.hu/api/network_rate/m/get_prices/EMAP' | jq -r '.data.data[]|select(.securityType == "PEMÁP") .name'); do

NAME=$(echo $X | tr \/ _ )


if [ ! -f PEMAP/${NAME}.html ]; then
    echo $NAME does not exist... let me create it
    cat quote_template.html >> PEMAP/${NAME}.html
fi

DATE=$(date +%F)


Q=$(curl -qs 'https://www.allampapir.hu/api/network_rate/m/get_prices/EMAP'  | jq -r ".data.data[] | select(.name == \"$X\") | .accruedInterest"| tr \, \. )
QUOTE=$(echo "scale = 6; 1+$Q/100" |bc)

LINE="<tr><td>$DATE</td><td>$QUOTE</td></tr>"
echo $LINE >> PEMAP/${NAME}.html

echo $NAME: $QUOTE
done


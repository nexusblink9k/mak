#!/bin/bash

for NAME in $(curl -qs 'https://www.allampapir.hu/api/network_rate/m/get_prices/DKJ' | jq -r '.data.data[].name'); do

if [ ! -f DKJ/${NAME}.html ]; then
    echo $NAME does not exist... let me create it
    cat quote_template.html >> DKJ/${NAME}.html
fi

DATE=$(date +%F)
QUOTE=0.$(curl -qs 'https://www.allampapir.hu/api/network_rate/m/get_prices/DKJ'  | jq -r ".data.data[] | select(.longName == \"$NAME\") | .bidPrice"| tr -d \,)

LINE="<tr><td>$DATE</td><td>$QUOTE</td></tr>"
echo $LINE >> DKJ/${NAME}.html

echo $NAME: $QUOTE
done


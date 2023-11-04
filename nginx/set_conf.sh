#!/bin/bash

export DOLLAR='$'

for file in /home/conf/*.conf.template
do
    name=$(basename $file .conf.template)
    envsubst < $file > /etc/nginx/conf.d/$name.conf
done

nginx -g 'daemon off;'
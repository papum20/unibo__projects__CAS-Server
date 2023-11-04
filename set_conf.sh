#!/bin/bash

export DOLLAR='$'

for file in nginx/conf/*.conf.template
do
    name=$(basename $file .conf.template)
    envsubst < $file > tmp/$name.conf
done

#!/bin/bash
sleep 25
service apache2 restart
cd /var/www/html/bugzilla
./checksetup.pl admin.conf
# Set custom db
# sed -i "s/\$db_host = 'localhost';/\$db_host = 'bugzilla_mysql';/" localconfig
# sed -i "s/\$db_pass = '';/\$db_pass = 'bugspsw';/" localconfig
# sed -i "s/\$webservergroup = 'apache';/\$webservergroup = 'www-data';/" localconfig
./checksetup.pl admin.conf
# ./testserver.pl http://localhost/bugzilla
echo "############# Bugzilla Started #############"
while :
do
  sleep 1
done

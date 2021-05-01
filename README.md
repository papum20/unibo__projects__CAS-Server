# CAS docker-compose configurations

## Sonarqube

Data | value
-----|-----
user | admin
password | admin
httpPort| 8121
httpsPort| 8122

Need this fix
```bash
  $ sysctl -w vm.max_map_count=262144
  $ echo "vm.max_map_count=262144" >> /etc/sysctl.conf
```

## Gitlab

  Data | value
  -----|-----
  httpPort | 9011
  httpsPort | 9021
  user | root
  password | Set at first login

## Taiga

Data | value
-----|-----
Port |9002
HttpsPort|9012
username | admin
password | 123123

### pre-installazione
#### Sostituire in variables.env
    TAIGA_HOST="yourIp"

###post-installazione
#### Sostituire in /conf/front/config.json
```
    "publicRegisterEnabled": true,
```
#### Impostare in /conf/back/config.py
```
    PUBLIC_REGISTER_ENABLED = True
```

## Mattermost
Data | value
-----|-----
Port | 9003
HttpsPort|9122

#### configuration
``` bash
docker-compose build
mkdir -pv ./volumes/app/mattermost/{data,logs,config,plugins,client-plugins}
sudo chmod -R 777 ./volumes/app/mattermost/
```

## Jenkins
Data | value
-----|-----
HttpPort | 9004
HttpsPort | 9014

Recupero password
```
$ docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

## Bugzilla
  Data | value
  -----|-----
  Port | 9005

#### Configuration
```bash
$ sudo docker exec -it bugzilla su -- bugzilla
$ [docker] mysql -h localhost -u root
$ [mysql] CREATE database bugs;
$ [mysql]CREATE USER 'bugs'@'localhost' IDENTIFIED BY 'bugs';
$ [mysql]SELECT User FROM mysql.user;
$ [mysql]GRANT ALL PRIVILEGES ON *.* TO 'bugs'@'localhost' WITH GRANT OPTION;
$ [mysql]SHOW GRANTS FOR 'bugs'@'localhost';
$ [docker] cd /var/www/html/bugzilla/
$ [docker]./checksetup.pl
```

#### Accessibile da {URL}:9005/bugzilla

## Logger-server
  Data | value
  -----|-----
  Port | 8120

Optional: can update CORS origin
```bash
docker exec -it logger su
[docker] apt install nano
[docker] nano api/config.py
```

## Dashboard
  Data | value
  -----|-----
  Port | 9010

Works with Logger-server as BackEnd.

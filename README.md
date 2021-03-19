# CAS docker-compose configurations

## Sonarqube

Data | value
-----|-----
port | 9000
user | admin
password | admin
proxyPort| 8121

Need this fix
```bash
  $ sysctl -w vm.max_map_count=262144
  $ echo "vm.max_map_count=262144" >> /etc/sysctl.conf
```

## Gitlab

  Data | value
  -----|-----
  port | 9001
  user | root
  password | Set at first login

## Taiga

Data | value
-----|-----
Port |9002
username | admin
password | 123123

#### Sostituire in /conf/front/config.json
```
    "api": "http://"your-ip":9002/api/v1/",
    "event":null,
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

#### configuration
``` bash
docker-compose build
mkdir -pv ./volumes/app/mattermost/{data,logs,config,plugins,client-plugins}
sudo chmod -R 777 ./volumes/app/mattermost/
```

## Jenkins
Data | value
-----|-----
Port | 9004

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

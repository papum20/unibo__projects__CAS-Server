# CAS docker-compose configurations

======================================================
Sonarqube
======================================================

port: 9000
default username: admin
default password: admin


Need this fix
# sysctl -w vm.max_map_count=262144 
And for the persistence configuration
# echo "vm.max_map_count=262144" >> /etc/sysctl.conf


=====================================================
Gitlab
=====================================================
Port: 9001
user: root
password: set at first login


=====================================================
Taiga
=====================================================

Port:9002
default username: admin
default password: 123123

Configurazione taiga front
# sostituire in /conf/front
    "api": "http://"your-ip":9002/api/v1/",
    "event":null,

=====================================================
Mattermost 
=====================================================

Port: 9003

Need build
#docker-compose build
Need create dirs
#mkdir -pv ./volumes/app/mattermost/{data,logs,config,plugins,client-plugins}
Need access
#sudo chmod -R 777 ./volumes/app/mattermost/

=====================================================
Jenkins
=====================================================

Port: 9004


=====================================================
Bugzilla
=====================================================

Port: 9005
Accessibile da URL:9005/bugzilla

Need configuration
#enter docker container
$ sudo docker exec -it bugzilla su -- bugzilla

#enter mysql console
$ mysql -h localhost -u root
$ CREATE database bugs;
$ CREATE USER 'bugs'@'localhost' IDENTIFIED BY 'bugs';
$ SELECT User FROM mysql.user;
$ GRANT ALL PRIVILEGES ON *.* TO 'bugs'@'localhost' WITH GRANT OPTION;
$ SHOW GRANTS FOR 'bugs'@'localhost';
$ exit

#complete setup
$ cd /var/www/html/bugzilla/
$ ./checksetup.pl



TODO: 
	-verificare mysql commands for bugzilla installation in cas.sh
  	-verificare se altri servizi funzionano(altrimenti prendere docker-compose da cas server installato su altra macchina)
	

# CAS server

## Installation
Edit the `.env` files (`.env` and `env/*`); in particular, you need to create files from the `.env.example` removing the `.example` extension.  
There's a script for creating random credentials in `env/credentials.env`, called `create-credentials.sh`.  

Then use `up.sh`.  
The given commands `down.sh`, `up.sh`, `rebuild.sh`, `ls.sh` respectively execute `docker compose` `down`, `up`, `down && up`, and `docker container ls` after having set up the environment correctly.  
The command `first-up.sh` should be executed at the first `up`, as initializes something before doing `up`.  

## Post-Installation: defaults, fixes, maintenance

### Sonarqube

Data | value
-----|-----
user | admin
password | admin

### Gitlab

Admin's username: `root`.  
Get admin's password (only valid for 24h): `/etc/gitlab/initial_root_password`.  
set password for admin: `docker exec -it gitlab gitlab-rake "gitlab:password:reset[root]"` (it takes a lot of time before showing password input prompt).  
other options at https://docs.gitlab.com/omnibus/installation/#set-up-the-initial-password.    

#### Remove Require admin approval fo signups
AdminArea-> Settings -> General -> Signup restrictions -> UNTICK Require admin approval for new sign-ups -> Save changes

### Taiga

Data | value
-----|-----
username | admin
password | 123123

### Jenkins
#### Recuperare password iniziale JENKINS
```bash
$ sudo docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
#### Abilitare registrazione utenti
Manage Jenkins -> Configure Global Security ->  Jenkins’ own user database -> -[x] Allow users to sign up

### Logger-server
- Optional: can update CORS origin
```bash
docker exec -it logger su
[docker] apt install nano
[docker] nano api/config.py
```

### Nginx

####  Automatizzare CertBot

```bash
sudo crontab -e
```
inserire
```
45 2 * * 6 certbot -q renew  
```

Testa il renew ogni sabato alle 2:45, si rinnova se scade in meno di 30 giorni

### KNOWN ISSUE
NON FUNZIONA RINNOVO AUTOMATICO.
```bash
$ sudo docker stop nginx
$ sudo certbot renew
$ sudo lsof -i:80
$ kill -9 [PIDS of lsof]
$ sudo docker start nginx
```

#### Check scadenza manuale
```bash
openssl x509 -noout -dates -in /etc/letsencrypt/live/aminsep.disi.unibo.it/cert.pem
```

### Gestione Spazio
In caso di occupazione completa dello spazio su disco:
```bash
  $  mount
  $  sudo lvextend -L +10G /dev/mapper/vg0-var
  $  sudo resize2fs /dev/mapper/vg0-var
```

### Backup
Some tips for doing backups, like for migrating server, moving files etc.  
1.	after moving bind mounts, you should change permissions and acls
	*	`sudo chown -R NEW_OWNER:docker CAS-Server`  
	*	`apt install acl; sudo setfacl -Rm g:docker:rwx volumes`
2.	if gitlab complains (in `docker logs gitlab`) about wrong permissions for gitaly.pid, delete it (it will recreate it) (https://gitlab.com/gitlab-org/omnibus-gitlab/-/issues/6926)
3.	for updating gitlab's permissions (suggested by gitlab ouput, idk):
	*	` docker exec -it gitlab update-permissions; docker restart gitlab`
	*	the docker-compose already does something for permissions (adding `:Z` which i don't know what does) (https://stackoverflow.com/a/31334443/20607105)
	
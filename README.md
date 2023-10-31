# CAS server

## Installation
Edit the `.env` files (`.env` and `env/*`); in particular, you need to create files from the `.env.example` removing the `.example` extension.  
There's a script for creating random credentials in `env/credentials.env`, called `create-credentials.sh`.  

Then use `up.sh`.  
The given commands `down.sh`, `up.sh` and `rebuild.sh` respectively execute `docker compose` `down`, `up` and `down && up`, after having set up the environment correctly.  

## Post-Installation: defaults and fixes

### Sonarqube

Data | value
-----|-----
user | admin
password | admin

### Gitlab

Admin's username: `root`.  
Get admin's password (only valid for 24h): `/etc/gitlab/initial_root_password`.  
set password for admin: `docker exec -it gitlab gitlab-rake "gitlab:password:reset[root]"`.
other options at https://docs.gitlab.com/omnibus/installation/#set-up-the-initial-password.    

#### Remove Require admin approval fo signups
AdminArea-> Settings -> General -> Signup restrictions -> UNTICK Require admin approval for new sign-ups -> Save changes

## Taiga

Data | value
-----|-----
username | admin
password | 123123

### Fixes

#### Exec container
```bash
$ sudo docker exec -it taiga-front su
```
#### Sostituire in conf.json
! you need to use VI
```
    "publicRegisterEnabled": true,
```
exit;
#### Exec container
```bash
$ sudo docker exec -it taiga-back su
```

#### Impostare in /settings/config.py
! you need to use VI
```
    PUBLIC_REGISTER_ENABLED = True
```
#### Restart Taiga-Back
```bash
$ sudo docker stop taiga-back
$ sudo docker start taiga-back
```

## Mattermost

## Jenkins
#### Recuperare password iniziale JENKINS
```bash
$ sudo docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
#### Abilitare registrazione utenti
Manage Jenkins -> Configure Global Security ->  Jenkins’ own user database -> -[x] Allow users to sign up

## Logger-server
- Optional: can update CORS origin
```bash
docker exec -it logger su
[docker] apt install nano
[docker] nano api/config.py
```

## Nginx

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

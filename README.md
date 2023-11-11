# CAS server

## Installation
Edit the `.env` files (`.env` and `env/*`); in particular, you need to create files from the `.env.example` removing the `.example` extension.  
Remember to set `LOCAL_DOCKER_GID` in `.env`. It's used to set the proper permissions for bind mounts (useful for backups and migrating server and volumes).  
There's a script for creating random credentials in `env/credentials.env`, called `create-credentials.sh`.  
Edit also `DOMAIN` in dashboard/env.  

Then use `up.sh`.  
The given commands `down.sh`, `up.sh`, `rebuild.sh`, `ls.sh` respectively execute `docker compose` `down`, `up`, `down && up`, and `docker container ls` after having set up the environment correctly.  
The command `first-up.sh` should be executed at the first `up`, as initializes something before doing `up`.  

For sonarqube, you need to apply `vm.max_map_count=262144` : add it to `/etc/sysctl.conf` to make it permanent; otherwise, you can run `sysctl -w vm.max_map_count=262144` to make it available for the current session.  

### Adding your services

All `FILE.conf.template` in `nginx/conf/` will be converted and used in the proxy configuration. You can add yours in such directory before deploying the containers. That's the same for `nginx/conf-dflt/`, which are the default ones, so put in a different directory, whereas `nginx/conf/` is ignored by `.gitignore`.  

Also `nginx/include/` (and `nginx/include-dflt/`) contain params for the confs.  

Finally, nginx's container uses as env files both `env/proxy.env` and `env/proxy-dflt.env`: again, `proxy-dflt.env` contains the default values, while `proxy.env` can be used for custom ones.   

## Post-Installation: defaults, fixes, maintenance

### Gitlab

Admin's username: `root`.  
Get admin's password (only valid for 24h): `/etc/gitlab/initial_root_password`.  
set password for admin: `docker exec -it gitlab gitlab-rake "gitlab:password:reset[root]"` (it takes a lot of time before showing password input prompt).  
other options at https://docs.gitlab.com/omnibus/installation/#set-up-the-initial-password.    

#### Remove Require admin approval fo signups
AdminArea-> Settings -> General -> Signup restrictions -> UNTICK Require admin approval for new sign-ups -> Save changes

### Jenkins

retrieve admin password:  
```bash
$ sudo docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Enable signup:  
Manage Jenkins -> Configure Global  Security ->  Jenkins’ own user  database -> -[x] Allow users to sign up  

Link with SonarQube:  
1.	create an account for jenkins on your sonarqube  
2.	give it (as admin) "execute analysis" permissions  
3.	generate a project token from jenkins account on sonarqube
4.	follow the configuration tutorial on sonarqube, which will appear after you initialize your first project with gitlab and jenkins
5.	in jenkins, (after having installed the sonar-scanner plugin) edit the sonar-scanner properties (in my case was `/var/jenkins_home/tools/hudson.plugins.sonar.SonarRunnerInstallation/SonarScanner4# cat conf/sonar-scanner.properties`): properly set `sonar.host.url`, `sonar.login`, `sonar.password`, `sonar.token`
6.	restart jenkins container and you're (probably) ready to go
7.	notes: 
	*	`sonar.password` is deprecated and you should use `sonar.token`, but i'm not sure it works so i use both;
	*	this was useful: https://stackoverflow.com/questions/50646519/sonarqube-jenkins-asks-for-login-and-password

Use roles for permissions: install Role-based Authorization Strategy plugin.  

### Sonarqube

Initial value: user=admin, password=admin; you will be asked to change the password at first login.  
Others can't still register, you have to enable it in the admin settings -> authentication, or invite them.  
I only enabled login and signup with gitlab:
1.	follow the given instructions in admin settings->authentication: you have to enable the sonarqube application from the admin area of your gitlab, and add the given credentials in the admin panel on sonarqube
2.	essential, or won't work: set server base url in admin->general (https://forum.gitlab.com/t/authenticate-sonarqube-using-gitlab/37897) (i don't know if it would be the same using `SONAR_HOST_URL`)

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
	
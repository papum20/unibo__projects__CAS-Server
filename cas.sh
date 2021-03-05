#!/bin/bash
programname=$0
DEFAULT_CAS_VERSION=2.0.0

function printLogo() {
  echo "  ######################################################################"
  echo "  #                                                                    #"
  echo "  #     ,o888888o.           .8.            d888888o.                  #"
  echo "  #    8888     '88.        .888.         .'8888:' '88.                #"
  echo "  # ,8 8888       '8.      :88888.        8.'8888.   Y8                #"
  echo "  # 88 8888               . '88888.       '8.'8888.                    #"
  echo "  # 88 8888              .8. '88888.       '8.'8888.                   #"
  echo "  # 88 8888             .8'8. '88888.       '8.'8888.                  #"
  echo "  # 88 8888            .8' '8. '88888.       '8.'8888.     _   _   _   #"
  echo "  # '8 8888       .8' .8'   '8. '88888.  8b   '8.'8888.   / \ / \ / \  #"
  echo "  #    8888     ,88' .888888888. '88888. '8b.  ;8.'8888  ( 2 ( . ( 0 ) #"
  echo "  #     '8888888P'  .8'       '8. '88888. 'Y8888P ,88P'   \_/ \_/ \_/  #"
  echo "  #                                                                    #"
  echo "  ######################################################################"
}

# Print usage guide
function usage (){
  echo "  ----------------------------- COMMANDS ----------------------------------"
  echo "  -i {site url} [version number]   Verify requirements and start installation"
  echo "  -r                               Start the system"
  echo "  -s                               Stop the system"
  echo "  -d                               Remove the system"
  echo "  -u {version number}              Search for updates"
  echo "  -h                               Show help"
  exit 1
}

function install() {
  echo "Starting CAS System Installation v. $1"
  # Checking for requirements
  echo "  [INSTALL 1/10] Checking requirements.."
  if exists docker; then
    echo "    DOCKER .............................. OK";
  else
    echo "    DOCKER .............................. NOT FOUND";
    sudo apt-get install docker.io;
  fi
  if exists docker-compose; then
    echo "    DOCKER-COMPOSE ...................... OK";
  else
    echo "    DOCKER-COMPOSE ...................... NOT FOUND";
    sudo apt-get install docker-compose;
  fi

  if exists nginx; then
    echo "    NGINX ............................... OK";
  else
    echo "    NGINX ............................... NOT FOUND";
    sudo apt-get install nginx;
  fi

  # Change file permissions
  echo "  [INSTALL 2/10] Change file permissions"
  sudo chmod 755 -R *

  # Start Gitlab INSTALLATION
  echo "  [INSTALL 3/10] Installing GitLab"
  echo "Creating volumes for GitLab..."
  cd docker-gitlab
  sudo docker-compose up -d

  # Start Mattermost INSTALLATION
  cd ../
  echo "  [INSTALL 4/10] Installing Mattermost"
  cd docker-mattermost
  sudo docker-compose build
  mkdir -pv ./volumes/app/mattermost/{data,logs,config,plugins,client-plugins}
  sudo chmod -R 755 ./volumes/app/mattermost/
  sudo docker-compose up -d

  # Start Sonarqube INSTALLATION
  cd ../
  echo "  [INSTALL 5/10] Installing Sonarqube"
  cd docker-sonar
  echo "  Fix WM MAX MAP COUNT "
  sudo sysctl -w vm.max_map_count=262144
  echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
  sudo docker-compose up -d



  # Start Taiga INSTALLATION
  cd ../
  echo "  [INSTALL 6/10] Installing Taiga"
  cd docker-taiga
  sudo docker-compose build
  sudo docker-compose up -d

  # Start Bugzilla INSTALLATION
  cd ../
  echo "  [INSTALL 7/10] Installing Bugzilla"
  cd docker-bugzilla
  sudo docker-compose build
  sudo docker-compose up -d
  echo "  Configuring Bugzilla ..."
  sleep 10
  sudo docker exec -it bugzilla su -- bugzilla -c  "mysql -h localhost -u root -Bse \"create database bugs; \
   CREATE USER 'bugs'@'localhost' IDENTIFIED BY 'bugs'; \
   SELECT User FROM mysql.user; \
   GRANT ALL PRIVILEGES ON *.* TO 'bugs'@'localhost' WITH GRANT OPTION;\"; \
   cd /var/www/html/bugzilla/; \
   ./checksetup.pl"

  # Start Logger INSTALLATION
  cd ../
  echo "  [INSTALL 8/10] Installing Logger"
  cd docker-logger
  sudo docker-compose build
  sudo docker-compose up -d

  # Start Jenkins INSTALLATION
  cd ../
  echo "  [INSTALL 9/10] Installing Jenkins"
  cd docker-jenkins
  sudo docker-compose up -d

  # Wait for operation completion
  echo "  [INSTALL 10/10] Waiting for operations' completion"
  cd ../../
  sudo service nginx stop

  sudo service nginx restart
  sleep 10

  # Operation completion, print information data
  echo "  [INSTALL 10/10] Installation Completed"
}



# Run all services
function startAll {
  echo "Starting CAS System..."

  # Start Gitlab
  echo "  [START 1/9] Starting GitLab"
  cd docker-gitlab
  sudo docker-compose start

  # Start Mattermost
  cd ../
  echo "  [START 2/9] Starting Mattermost"
  cd docker-mattermost
  sudo docker-compose start

  # Start Sonarqube
  cd ../
  echo "  [START 3/9] Starting Sonarqube"
  cd docker-sonar
  sudo docker-compose start

  # Start Taiga
  cd ../
  echo "  [START 4/9] Starting Taiga"
  cd docker-taiga
  sudo docker-compose start

  # Start Bugzilla
  cd ../
  echo "  [START 5/9] Starting Bugzilla"
  cd docker-bugzilla
  sudo docker-compose start

  # Start Logger
  cd ../
  echo "  [START 6/9] Starting Logger"
  cd docker-logger
  sudo docker-compose start

  cd ../
  echo "  [START 7/9] Starting Jenkins"
  cd docker-jenkins
  sudo docker-compose start

  # Wait for operation completion
  echo "  [START 8/9] Waiting for operations' completion"

  # Operation completion, print information data
  echo "  [START 9/9] All services are now running"
}


# Stop all services
function stopAll {
  echo "Stopping CAS System..."
  cd cas-components

  # Stop Gitlab
  echo "  [STOP 1/9] Stopping GitLab"
  cd docker-gitlab
  sudo docker-compose stop


  # Stop Mattermost
  cd ../
  echo "  [STOP 2/9] Stopping Mattermost"
  cd docker-mattermost
  sudo docker-compose stop

  # Stop Sonarqube
  cd ../
  echo "  [STOP 3/9] Stopping Sonarqube"
  cd docker-sonar
  sudo docker-compose stop

  # Stop Taiga
  cd ../
  echo "  [STOP 4/9] Stopping Taiga"
  cd docker-taiga
  sudo docker-compose stop

  # Stop Bugzilla
  cd ../
  echo "  [STOP 5/9] Stopping Bugzilla"
  cd docker-bugzilla
  sudo docker-compose stop

  # Stop Logger
  cd ../
  echo "  [STOP 6/9] Stopping Logger"
  cd docker-logger
  sudo docker-compose stop

  # Stop Jenkins
  cd ../
  echo "  [STOP 7/9] Stopping Jenkins"
  cd docker-jenkins
  sudo docker-compose stop

  # Wait for operation completion
  echo "  [STOP 8/9] Waiting for operations' completion"
  sleep 10


  # Operation completion, print information data
  echo "  [STOP 9/9] All services are now stopped"
}


# Delete all services
function deleteAll {
  echo "Deleting CAS System..."

  # Delete Gitlab
  echo "  [DELETE 1/9] Deleting GitLab"
  cd docker-gitlab
  sudo docker-compose rm


  # Delete Mattermost
  cd ../
  echo "  [DELETE 2/9] Deleting Mattermost"
  cd docker-mattermost
  sudo docker-compose rm

  # Delete Sonarqube
  cd ../
  echo "  [DELETE 3/9] Deleting Sonarqube"
  cd docker-sonar
  sudo docker-compose rm

  # Delete Taiga
  cd ../
  echo "  [DELETE 4/9] Deleting Taiga"
  cd docker-taiga
  sudo docker-compose rm

  # Delete Bugzilla
  cd ../
  echo "  [DELETE 5/9] Deleting Bugzilla"
  cd docker-bugzilla
  sudo docker-compose rm

  # Delete Logger
  cd ../
  echo "  [DELETE 6/9] Deleting Logger"
  cd docker-logger
  sudo docker-compose rm

  # Delete Jenkins
  cd ../
  echo " [DELETE 7/9] Deleting Jenkins"
  cd docker-jenkins
  sudo docker-compose rm

  # Wait for operation completion
  echo "  [DELETE 8/9] Waiting for operations' completion"
  sleep 10


  # Operation completion, print information data
  echo "  [STOP 9/9] All services has been removed"
}

exists()
{
  command -v "$1" >/dev/null 2>&1
}

printLogo

if [ "$#" -lt 1 ]; then
  usage
fi

while getopts ":hirsdu:" opt; do
  case $opt in
    h)
      usage
      ;;
    i)
      shift $(($OPTIND - 1))
	  site_url=$@
	  shift $(($OPTIND - 1))
	  cas_ver=$@
      if [ -z "$cas_ver" ]
      then
        install $site_url $DEFAUTL_CAS_VERSION
      else
        install $site_url $cas_ver
      fi
      ;;
    r)
      startAll
      ;;
    s)
      stopAll
      ;;
    d)
      deleteAll
      # Remove all volumes with persistent data
      sudo docker volume prune
      sudo docker network prune
      ;;
    u)
      cas_ver=$OPTARG
      deleteAll
      install $cas_ver
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
    ;;
  esac
done

exit 1

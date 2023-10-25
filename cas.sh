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
  echo "  -i                               Verify requirements and start installation"
  echo "  -r                               Start the system"
  echo "  -s                               Stop the system"
  echo "  -d                               Remove the system"
  echo "  -h                               Show help"
  exit 1
}

function install() {
  echo "Starting CAS System Installation v. $1"
  # Checking for requirements
  echo "  [INSTALL 0/7] Clean previous dockers and packages"
  echo "  \"apt clean\""
  echo "  \"docker container prune -f\""
  echo "  \"docker image prune -f\""
  read -r -p "  Want to execute the above commands first? [y/N] " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
  then
    apt clean
    docker container prune -f
    docker image prune -f
  fi

  echo "  [INSTALL 1/7] Checking requirements.."
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
  echo "  [INSTALL 2/7] Get certificate for TLS Encrypt"
  sudo snap install core
  sudo snap refresh core
  sudo snap install --classic certbot

  read -r -p "Have you domain for install TLS? [y/N] " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
  then
    echo -n "Enter domain for TLS certificate: "
    read domain
    sudo certbot certonly --nginx -d $domain || (echo "[ERROR] Insert valid domain."; exit) ;
    sed -i "s/TAIGA_HOST=.*/TAIGA_HOST=$domain/" ./env/taiga.env;
    sed -i "s/TAIGA_PORT=.*/TAIGA_PORT=443/" ./env/taiga.env;
    sed -i "s/TAIGA_SCHEME=.*/TAIGA_SCHEME=https/" ./env/taiga.env;
    sed -i "s/URL:.*/URL: \x22 https:\/\/$domain\x22,/" ./configs/dashboard.js;
    sed -i "s/PORT_NUMBER:.*/PORT_NUMBER: \x22442\x22,/" ./configs/dashboard.js;
    sed -i "s/external_url .*/external_url \x27https:\/\/$domain\/gitlab\x27/" ./docker-compose.yml;
    sed -i "s/\x22homepage\x22:.*/\x22homepage\x22:\x22https:\/\/$domain\/dashboard\x22,/" ./configs/dashboard.json;
    sed -i "s/_.*/_https.conf \/etc\/nginx\/conf.d\/default.conf/" ./docker-nginx/Dockerfile;
    sed -i "s/server_name .*/server_name   $domain;/" ./docker-nginx/default_https.conf;
    sed -i "s/ssl_certificate /etc/letsencrypt/live/: .*/ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;/" ./docker-nginx/default_https.conf;
    sed -i "s/ssl_certificate_key /etc/letsencrypt/live/: .*/ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;/" ./docker-nginx/default_https.conf;
  else
    echo "[INFO] CAS-server will install on localhost";
    sed -i "s/TAIGA_HOST=.*/TAIGA_HOST=localhost/" ./env/taiga.env;
    sed -i "s/TAIGA_PORT=.*/TAIGA_PORT=80/" ./env/taiga.env;
    sed -i "s/TAIGA_SCHEME=.*/TAIGA_SCHEME=http/" ./env/taiga.env;
    sed -i "s/URL:.*/URL: \x22 http:\/\/localhost\x22,/" ./configs/dashboard.js;
    sed -i "s/PORT_NUMBER:.*/PORT_NUMBER: \x2280\x22,/" ./configs/dashboard.js;
    sed -i "s/external_url .*/external_url \x27http:\/\/localhost\/gitlab\x27/" ./docker-compose.yml;
    sed -i "s/\x22homepage\x22:.*/\x22homepage\x22:\x22http:\/\/localhost\/dashboard\x22,/" ./configs/dashboard.json;
    sed -i "s/_.*/_http.conf \/etc\/nginx\/conf.d\/default.conf/" ./docker-nginx/Dockerfile;
  fi

  # Change file permissions
  echo "  [INSTALL 3/7] Change file permissions"
  sudo chmod 755 -R *

  echo "  [INSTALL 4/8] Check old configs"
  sudo docker volume rm -f cas-server_taiga_conf cas-server_gitlab_config cas-server_logger_conf cas-server_mattermost_config

  echo "  [INSTALL 4/7] Installing CAS-server"
  sudo docker-compose build --no-cache

  echo "  [INSTALL 5/7] Finalization"
  cd docker-mattermost
  sudo chmod -R 777 ./config
  sudo sysctl -w vm.max_map_count=262144
  echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
  cd ../

  echo "  [INSTALL 6/7] Starting server"
  sudo docker-compose up -d

  # Operation completion, print information data
  echo "  [INSTALL 7/7] CAS-Server is up and running"
}



# Run all services
function startAll {
  echo "Starting CAS System..."
  sudo docker-compose start

  # Operation completion, print information data
  echo "All services are now running"
}


# Stop all services
function stopAll {
  echo "Stopping CAS System..."
  sudo docker-compose stop
  echo "All services are now stopped"
}


# Delete all services
function deleteAll {
  echo "Deleting CAS System..."
  sudo docker-compose rm

  echo "All services has been removed"
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
      install $DEFAUTL_CAS_VERSION
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

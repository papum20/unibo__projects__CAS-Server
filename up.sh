#!/bin/bash

# volumes

set -a
source .env
source env/credentials.env
mkdir ${DASHBOARD_HOME} ${GITLAB_HOME} ${LOGGER_HOME}

# mattermost
mkdir -p ./volumes/app/mattermost/{config,data,logs,plugins,client/plugins,bleve-indexes}
sudo chown -R 2000:2000 ./volumes/app/mattermost

# start
docker compose \
    -f docker-compose.dashboard.yml \
    -f docker-compose.gitlab.yml \
    -f docker-compose.jenkins.yml \
    -f docker-compose.logger.yml \
    -f docker-compose.mattermost.yml \
    -f docker-compose.sonarqube.yml \
    -f docker-compose.taiga.yml \
    -f docker-compose.yml \
    up -d
#!/bin/bash

# environment
set -a
source env/proxy.env
source env/credentials.env
source .env

# volumes
mkdir -p \
    ${DASHBOARD_VOLUME} \
    ${GITLAB_VOLUME} \
    ${GRAFANA_VOLUME_DATA} \
    ${PROMETHEUS_VOLUME} 

## mattermost
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
#!/bin/bash

# volumes

## dashboard
mkdir dashboard
export DASHBOARD_HOME=$(pwd)/dashboard

## gitlab
mkdir gitlab 
export GITLAB_HOME=$(pwd)/gitlab

## logger
mkdir logger
export LOGGER_HOME=$(pwd)/logger

# mattermost
mkdir -p ./volumes/app/mattermost/{config,data,logs,plugins,client/plugins,bleve-indexes}
sudo chown -R 2000:2000 ./volumes/app/mattermost

# start
docker-compose up -d \
    -f docker-compose.dashboard.yml \
    -f docker-compose.gitlab.yml \
    -f docker-compose.jenkins.yml \
    -f docker-compose.logger.yml \
    -f docker-compose.mattermost.yml \
    -f docker-compose.sonar.yml \
    -f docker-compose.taiga.yml \
    -f docker-compose.yml
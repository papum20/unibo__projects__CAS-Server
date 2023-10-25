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
docker-compose up -d
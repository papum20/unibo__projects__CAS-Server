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

# env
source ./env/mattermost.env
#source ./env/sonar.env
source ./env/taiga.env

# start
docker-compose up -d
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

# start
docker-compose up -d
#!/bin/bash

./down.sh
set -a
source env/proxy.env env/credentials.env .env
docker compose \
    -f docker-compose.dashboard.yml \
    -f docker-compose.gitlab.yml \
    -f docker-compose.jenkins.yml \
    -f docker-compose.logger.yml \
    -f docker-compose.mattermost.yml \
    -f docker-compose.sonarqube.yml \
    -f docker-compose.taiga.yml \
    -f docker-compose.yml \
    build --no-cache
./up.sh
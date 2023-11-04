#!/bin/bash

./down.sh
set -a
source env/proxy.env
source env/credentials.env
source .env
docker compose $(ls docker-compose*.yml | awk '{printf "-f %s ", $0}') build --no-cache
./up.sh
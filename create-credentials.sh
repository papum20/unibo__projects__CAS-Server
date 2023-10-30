#!/bin/bash

CREDENTIALS_LENGTH_USER=8
CREDENTIALS_LENGTH_PASSWORD=16

replace_random() {
    local length=$1
    tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w "$length" | head -n 1
}

cat > env/credentials.env <<EOF
# Mattermost
CREDENTIALS_MATTERMOST_POSTGRES_USER=$(replace_random $CREDENTIALS_LENGTH_USER)
CREDENTIALS_MATTERMOST_POSTGRES_PASSWORD=$(replace_random $CREDENTIALS_LENGTH_PASSWORD)

# SonarQube
CREDENTIALS_SONAR_JDBC_USERNAME=$(replace_random $CREDENTIALS_LENGTH_USER)
CREDENTIALS_SONAR_JDBC_PASSWORD=$(replace_random $CREDENTIALS_LENGTH_PASSWORD)

# Taiga
CREDENTIALS_TAIGA_SECRET_KEY=$(replace_random $CREDENTIALS_LENGTH_PASSWORD)

CREDENTIALS_TAIGA_POSTGRES_USER=$(replace_random $CREDENTIALS_LENGTH_USER)
CREDENTIALS_TAIGA_POSTGRES_PASSWORD=$(replace_random $CREDENTIALS_LENGTH_PASSWORD)

CREDENTIALS_TAIGA_EMAIL_HOST_USER=$(replace_random $CREDENTIALS_LENGTH_USER)
CREDENTIALS_TAIGA_EMAIL_HOST_PASSWORD=$(replace_random $CREDENTIALS_LENGTH_PASSWORD)

CREDENTIALS_TAIGA_RABBITMQ_USER=$(replace_random $CREDENTIALS_LENGTH_USER)
CREDENTIALS_TAIGA_RABBITMQ_PASS=$(replace_random $CREDENTIALS_LENGTH_PASSWORD)
EOF
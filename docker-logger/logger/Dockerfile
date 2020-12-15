# Pull base image.
FROM ubuntu:18.04

# Set environment variables.
ARG REPO_BRANCH
ARG SECRET_KEY
ARG SECURITY_PASSWORD_SALT
ARG SECRET_DB_NAME


ENV REPO_BRANCH $REPO_BRANCH
ENV SECRET_KEY $SECRET_KEY
ENV SECURITY_PASSWORD_SALT $SECURITY_PASSWORD_SALT
ENV SECRET_DB_NAME $SECRET_DB_NAME

ENV HOME /root
ENV PYTHONPATH ":/api:/db"
ENV INNOMETRICS_BACKEND_PATH "/root/logger"

# Define working directory.
WORKDIR /root

SHELL ["/bin/bash", "-c"]

# Install.
RUN \
  # apt-get update && \
  # apt-get install -y software-properties-common && \
  # add-apt-repository ppa:jonathonf/python-3.6 && \
  apt-get update && \
  apt-get -y upgrade && \
  # apt-get install -y python3.6 && \
  apt-get install -y git && \
  apt-get install -y virtualenv && \
  # apt-get install -y  python-pip && \
  apt-get install -y  python3-pip && \
  ln -s /usr/bin/pip3 /usr/bin/pip && \
  git clone --branch $REPO_BRANCH https://github.com/InnopolisUniversity/innometrics-backend logger && \
  cd logger && \
  # rm config.ini && \
  rm requirements.txt && \
  mkdir logs && \
  touch logs/errors.log && \
  touch config_proudction.ini && \
  echo "[FLASK]" >> config_proudction.ini && \
  echo "DEBUG = False" >> config_proudction.ini && \
  echo "SECRET_KEY = $SECRET_KEY" >> config_proudction.ini && \
  echo "SECURITY_PASSWORD_SALT = $SECURITY_PASSWORD_SALT" >> config_proudction.ini && \
  echo "PORT = 8120" >> config_proudction.ini && \
  echo "" >> config_proudction.ini && \
  echo "[MONGO]" >> config_proudction.ini && \
  echo "MONGO_DB = $SECRET_DB_NAME" >> config_proudction.ini && \
  echo "MONGO_HOST = mongodb" >> config_proudction.ini && \
  echo "MONGO_PORT = 27017" >> config_proudction.ini && \
  chmod u+x deployment.sh


# Add files.
#ADD config_proudction.ini ./logger
ADD requirements.txt ./logger
ADD run.sh ./logger


WORKDIR /root/logger

RUN ./deployment.sh

# Define default command.
CMD ./run.sh

# pull official base image
FROM ubuntu:20.04

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Define working directory.
WORKDIR /root

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    # install apt-utils, for error
    # 'Docker Error - debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module)'
    # (https://linuxamination.blogspot.com/2021/05/docker-error-debconf-cant-locate.html)
    apt-get install apt-utils && \
    apt-get install -y curl && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    # install python, needed for nvm
    apt-get install -y python && \
    # update node: first install nvm, activate it and then install node
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvm install node && \
    # continue installation
    apt-get install -y gnupg2 && \
    apt-get install -y git && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&  apt-get update &&   apt-get install -y yarn


# add app
RUN git clone https://github.com/papum20/unibo__projects__CAS-dashboard.git CAS-dashboard

WORKDIR /root/CAS-dashboard

# install app dependencies
# RUN yarn upgrade
# increased timeout needed for slower systems, because @material-ui/icons is quite large (https://github.com/mui/material-ui/issues/12432)
RUN yarn --network-timeout 500000
COPY ./configs/dashboard.json ./package.json
COPY ./configs/dashboard.js ./src/services/config.js
RUN yarn build
RUN yarn global add serve
# start app
CMD serve -s build

# pull official base image
FROM ubuntu:20.04

ENV PATH /app/node_modules/.bin:$PATH
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /root
SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    # install apt-utils, for error
    # 'Docker Error - debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module)'
    # (https://linuxamination.blogspot.com/2021/05/docker-error-debconf-cant-locate.html)
    # unable to initialize frontend: Dialog (https://github.com/moby/moby/issues/27988)
    apt-get install -y dialog apt-utils && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y curl && \
    # 
    apt-get install -y gnupg2 git npm \
    # ERROR  Cannot copy server address to clipboard: Couldn't find the `xsel` binary and fallback didn't work. On Debian/Ubuntu you can install xsel with: sudo apt install xsel.
    xsel
# set node version
RUN npm install --global n && \
    n 16
RUN npm install --global yarn

RUN git clone https://github.com/papum20/unibo__projects__CAS-dashboard.git CAS-dashboard

# install app dependencies

WORKDIR /root/CAS-dashboard
COPY ./dashboard/.env ./.env
COPY ./dashboard/package.json ./package.json
COPY ./dashboard/config.js.template ./src/services/config.js.template
RUN "envsubst < ./src/services/config.js.template > ./src/services/config.js"

# RUN yarn upgrade"

# fix security issues; in particular, there was a major change with node17 (https://stackoverflow.com/a/73027407/20607105)
#RUN npm_config_yes=true npx yarn-audit-fix
#RUN npm audit fix --force

RUN yarn global add serve
# increased timeout needed for slower systems, because @material-ui/icons is quite large (https://github.com/mui/material-ui/issues/12432)
RUN yarn --network-timeout 500000
RUN yarn build
# start app
CMD serve -s build

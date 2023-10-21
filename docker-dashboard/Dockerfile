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
    # unable to initialize frontend: Dialog (https://github.com/moby/moby/issues/27988)
    apt-get install -y dialog apt-utils && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y curl && \
    # 
    apt-get install -y gnupg2 git npm \
    # ERROR  Cannot copy server address to clipboard: Couldn't find the `xsel` binary and fallback didn't work. On Debian/Ubuntu you can install xsel with: sudo apt install xsel.
    xsel \
    # debug
    net-tools
    # yarn, n to update node
RUN npm install --global n && \
    n 16
    # update node: first install nvm, activate it and then install node
    #curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && \
    #export NVM_DIR="$HOME/.nvm" && \
    #[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    #[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    #nvm install node && echo "$(node -v)"
    # 
RUN npm install --global yarn


# add app
RUN git clone https://github.com/papum20/unibo__projects__CAS-dashboard.git CAS-dashboard

WORKDIR /root/CAS-dashboard

# install app dependencies
# RUN yarn upgrade"
# increased timeout needed for slower systems, because @material-ui/icons is quite large (https://github.com/mui/material-ui/issues/12432)

# fix security issues; in particular, there was a major change with node17 (https://stackoverflow.com/a/73027407/20607105)
#RUN npm_config_yes=true npx yarn-audit-fix
#RUN npm audit fix --force

RUN yarn global add serve
RUN yarn --network-timeout 500000
COPY ./configs/dashboard.json ./package.json
COPY ./configs/dashboard.js ./src/services/config.js
RUN yarn build
# start app
CMD serve -s build

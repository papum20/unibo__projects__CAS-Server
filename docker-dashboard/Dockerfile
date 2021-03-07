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
    apt-get install -y curl && \
    apt-get install -y gnupg2 && \
    apt-get install -y git && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn


# add app
RUN git clone https://github.com/elPeroN/CAS-dashboard.git CAS-dashboard

WORKDIR /root/CAS-dashboard

# install app dependencies
RUN yarn

# start app
CMD ["yarn", "start"]

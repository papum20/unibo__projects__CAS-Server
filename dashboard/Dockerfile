
FROM node:20.9.0-bullseye-slim

RUN apt-get update && apt-get install -y --no-install-recommends dumb-init
# only install production dependencies
ENV NODE_ENV production
WORKDIR /usr/src/app
# don't run as root #1
COPY --chown=node:node dashboard .
# clean install
RUN npm ci --only=production
# don't run as root #2
USER node

COPY --chown=node:node dashboard/entrypoint.sh /usr/src/app/
# node isn't suitable to be run as pid 1, dumb-init is like a wrapper
CMD ["/usr/src/app/entrypoint.sh"]

# https://snyk.io/blog/10-best-practices-to-containerize-nodejs-web-applications-with-docker/

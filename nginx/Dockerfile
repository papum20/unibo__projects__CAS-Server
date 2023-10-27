FROM nginx

COPY ./nginx/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY ./nginx/mattermost_params /etc/nginx/mattermost_params
COPY ./nginx/proxy_params /etc/nginx/proxy_params

CMD /bin/bash -c "export DOLLAR='$' && \
    envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
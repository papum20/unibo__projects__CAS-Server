FROM nginx:1.19-alpine

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./nginx/mattermost_params /etc/nginx/mattermost_params
COPY ./nginx/proxy_params /etc/nginx/proxy_params

CMD /bin/bash -c "export DOLLAR='$' && envsubst < ./nginx/default.conf > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
FROM nginx

COPY ./nginx/conf/ /home/conf/
COPY ./nginx/params/ /etc/nginx/
COPY ./nginx/set_conf.sh /home/set_conf.sh

RUN chmod +x /home/set_conf.sh
CMD ["/home/set_conf.sh"]
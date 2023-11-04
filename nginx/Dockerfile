FROM nginx

COPY ./nginx/conf-dflt/ /home/conf/
COPY ./nginx/conf/ /home/conf/
COPY ./nginx/include-dflt/ /etc/nginx/
COPY ./nginx/include/ /etc/nginx/
COPY ./nginx/set_conf.sh /home/set_conf.sh

RUN chmod +x /home/set_conf.sh
CMD ["/home/set_conf.sh"]
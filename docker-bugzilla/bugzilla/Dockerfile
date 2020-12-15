# Pull base image.
FROM ubuntu:14.04

ARG REPO_BRANCH
ENV REPO_BRANCH $REPO_BRANCH

# Define working directory.
WORKDIR /root

SHELL ["/bin/bash", "-c"]

# Install.
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install git nano && \
  apt-get -y install apache2 mysql-server libappconfig-perl libdate-calc-perl libtemplate-perl libmime-perl build-essential libdatetime-timezone-perl libdatetime-perl libemail-sender-perl libemail-mime-perl libemail-mime-modifier-perl libdbi-perl libdbd-mysql-perl libcgi-pm-perl libmath-random-isaac-perl libmath-random-isaac-xs-perl apache2-mpm-prefork libapache2-mod-perl2 libapache2-mod-perl2-dev libchart-perl libxml-perl libxml-twig-perl perlmagick libgd-graph-perl libtemplate-plugin-gd-perl libsoap-lite-perl libhtml-scrubber-perl libjson-rpc-perl libdaemon-generic-perl libtheschwartz-perl libtest-taint-perl libauthen-radius-perl libfile-slurp-perl libencode-detect-perl libmodule-build-perl libnet-ldap-perl libauthen-sasl-perl libtemplate-perl-doc libfile-mimeinfo-perl libhtml-formattext-withlinks-perl libfile-which-perl libgd-dev libmysqlclient-dev lynx-cur graphviz python-sphinx rst2pdf && \
  cd /var/www/html && \
  git clone --branch $REPO_BRANCH https://github.com/bugzilla/bugzilla bugzilla


# Add files.
ADD bugzilla.conf /etc/apache2/sites-available/
ADD run.sh /root

RUN \
a2ensite bugzilla && \
a2enmod cgi headers expires && \
cd /var/www/html/bugzilla && \
/usr/bin/perl install-module.pl --all


ADD admin.conf /var/www/html/bugzilla

WORKDIR /root

# RUN ./deployment.sh

# Define default command.
CMD ./run.sh

FROM ubuntu:xenial
MAINTAINER Makoto Abe

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get -y install supervisor git apache2 libapache2-mod-php7.0 mysql-server-5.7 \
  php7.0-mysql pwgen php-apcu php7.0-mcrypt && \
  echo "ServerName localhost" >> /etc/apache2/apache2.conf

# editor install
RUN apt-get update && \
  apt-get -y install vim


# Add image configuration and scripts
ADD start-apache2.sh /start-apache2.sh
ADD start-mysqld.sh /start-mysqld.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
#ADD my.cnf /etc/mysql/conf.d/my.cnf
COPY etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD change_mysql_root_password.sh /change_mysql_root_password.sh
RUN chmod 755 /*.sh

# add configuration appahe2
COPY etc/apache2/envvars /etc/apache2/envvars

# config to enable .htaccess
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Configure /app folder with sample app
# RUN git clone https://github.com/m0a/hello-world-lamp /app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

#Environment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

#user group add
RUN groupadd -g 1000 docker
RUN useradd  -g 1000 docker


# Add volumes for MySQL 
VOLUME  ["/etc/mysql", "/var/lib/mysql", "/app" ]

EXPOSE 80 3306
CMD ["/run.sh"]

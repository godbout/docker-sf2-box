FROM ubuntu:14.04
MAINTAINER Guillaume Leclerc <guill.bout@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
	apt-get install -y supervisor nginx php5-fpm php5-cli mysql-server php5-mysql pwgen

# Clean image
RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Supervisord conf
ADD supervisord/nginx.conf /etc/supervisor/conf.d/nginx.conf
ADD supervisord/php5-fpm.conf /etc/supervisor/conf.d/php5-fpm.conf
ADD supervisord/mysqld.conf /etc/supervisor/conf.d/mysqld.conf

# Nginx conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD nginx/sites-enabled/ /etc/nginx/sites-enabled/
ADD nginx/conf.d/ /etc/nginx/conf.d/

# Php-fpm conf
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf

# Mysql conf
RUN rm -rf /var/lib/mysql/*
ADD mysql/my.cnf /etc/mysql/conf.d/my.cnf
ADD mysql/create_mysql_users.sh /create_mysql_users.sh
RUN chmod 755 /*.sh

EXPOSE 80

# Add launching script
ADD run.sh /run.sh
RUN chmod 755 /*.sh

CMD ["/run.sh"]
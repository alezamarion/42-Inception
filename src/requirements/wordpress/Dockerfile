FROM debian:oldstable

WORKDIR /var/www/html/

RUN apt update -y && apt upgrade && apt install -y php-fpm php-mysql mariadb-client wget sudo

RUN sed -i.default "/^listen\s=.*/c\listen = 0.0.0.0:9000" /etc/php/[0-9]*.[0-9]*/fpm/pool.d/www.conf

COPY ./tools/wp_install.sh /tmp/wp_install.sh

RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp

WORKDIR	/var/www/html/wordpress

RUN	mkdir -p /run/php

CMD ["sh", "/tmp/wp_install.sh"]

# setting up a Debian-based container for hosting a WordPress website using PHP-FPM and MariaDB. 
FROM debian:oldstable

#This command sets the working directory within the container to /var/www/html/. 
#This is where web content and PHP scripts will be placed.
WORKDIR /var/www/html/

#This line updates the package index, upgrades installed packages, and then installs several packages using the APT package 
 #manager. These packages include PHP-FPM for PHP support, PHP-MySQL for MySQL database support, MariaDB client tools, 
 #wget for downloading files, and sudo.
RUN apt update -y && apt upgrade && apt install -y php-fpm php-mysql mariadb-client wget sudo

#This line uses sed to modify the PHP-FPM configuration file (www.conf) to change the default listening address and port 
 #to 0.0.0.0:9000. This allows PHP-FPM to listen on all available network interfaces so that it can accept incoming connections 
 #from other containers or external sources.
RUN sed -i.default "/^listen\s=.*/c\listen = 0.0.0.0:9000" /etc/php/[0-9]*.[0-9]*/fpm/pool.d/www.conf

#This command copies a script named wp_install.sh from the local filesystem (relative to the Dockerfile) to the /tmp directory 
#within the Docker image. This script is likely used for installing and configuring WordPress.
COPY ./tools/wp_install.sh /tmp/wp_install.sh

#This series of commands downloads the WP-CLI (WordPress Command Line Interface) tool, makes it executable with chmod, 
 #and moves it to the /usr/bin directory so that it can be executed from any location in the container.
RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp

#This command changes the working directory to /var/www/html/wordpress. This is where the WordPress application files are 
 #expected to be installed.
WORKDIR	/var/www/html/wordpress

#This command creates the /run/php directory. This directory is typically used for storing PHP-FPM socket files.
RUN	mkdir -p /run/php

#The CMD instruction specifies the default command to run when a container is started from this image. 
 #In this case, it runs the wp_install.sh script using the sh shell. This script is likely responsible for installing and 
 #configuring WordPress
CMD ["sh", "/tmp/wp_install.sh"]
FROM debian:oldstable

#These lines declare build arguments that allow you to pass values into the Docker image at build time. 
#These arguments are used to customize the database name, database user, and database password when building the image.
ARG WORDPRESS_DB_NAME
ARG WORDPRESS_DB_USER
ARG WORDPRESS_DB_PASSWORD

#Updates the package index of the Debian system.
#Upgrades the installed packages to their latest versions.
#Installs the MariaDB server on the image. The -y flag automatically answers "yes" to any prompts during the installation.
RUN apt update -y && apt upgrade && apt install mariadb-server -y

#his line appends configuration options to the MariaDB configuration file located at /etc/mysql/my.cnf. 
#It adds the [mysqld] section and sets the skip-networking and skip-bind-address options to enable network connections 
#to the database.
RUN echo "[mysqld] \n skip-networking=0 \n skip-bind-address" >> /etc/mysql/my.cnf

#starts the MariaDB service and then uses the mariadb` command-line tool to execute SQL commands to set up the database and user
#&& service mariadb stop: After setting up the database and user, this line stops the MariaDB service. 
#This is done to keep the image lightweight since it's not meant to run the database as a long-running service but 
 #rather as part of a containerized environment.
#CMD ["mysqld_safe"]: this line specifies the default command to run when a container is started from this image. 
 #It runs the mysqld_safe command, which is used to start the MariaDB server. This is the process that will be running when you run a container from this image.
#'$WORDPRESS_DB_USER'@'%' syntax means that this user is allowed to connect from any host ('%')
#FLUSH PRIVILEGES;: This command flushes the privilege tables to apply the changes made with the GRANT command immediately.
 #Without this step, the changes may not take effect until MariaDB is restarted.
#&& service mariadb stop: After setting up the database and user, this line stops the MariaDB service. 
 #Stopping the service is done to ensure that the changes made during the setup process are saved and that the database 
 #is not running as a background service within the Docker container. This keeps the container lightweight and suitable 
 #for its intended use, which is to run the MariaDB server only when needed, such as when a container is started from this image.
#ON $WORDPRESS_DB_NAME.*: The asterisk (*) in this part indicates that the privileges are granted to the user on all tables
 #and objects within the specified database ($WORDPRESS_DB_NAME)
RUN service mariadb start && mariadb -u root -e \
	"CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME; \
	CREATE USER '$WORDPRESS_DB_USER'@'%' identified by '$WORDPRESS_DB_PASSWORD'; \
	GRANT ALL ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'; \
	FLUSH PRIVILEGES;" && service mariadb stop

CMD ["mysqld_safe"]
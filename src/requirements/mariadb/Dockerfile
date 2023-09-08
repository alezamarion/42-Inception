FROM debian:oldstable

ARG WORDPRESS_DB_NAME
ARG WORDPRESS_DB_USER
ARG WORDPRESS_DB_PASSWORD

RUN apt update -y && apt upgrade && apt install mariadb-server -y

RUN echo "[mysqld] \n skip-networking=0 \n skip-bind-address" >> /etc/mysql/my.cnf

RUN service mariadb start && mariadb -u root -e \
	"CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME; \
	CREATE USER '$WORDPRESS_DB_USER'@'%' identified by '$WORDPRESS_DB_PASSWORD'; \
	GRANT ALL ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'; \
	FLUSH PRIVILEGES;" && service mariadb stop

CMD ["mysqld_safe"]

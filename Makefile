all: set_host
	@ sudo mkdir -p /home/azamario/data/mysql
	@ docker volume create --name mariadb_volume --opt type=none --opt device=/home/azamario/data/mysql --opt o=bind
	@ sudo mkdir -p /home/azamario/data/wordpress
	@ docker volume create --name wordpress_volume --opt type=none --opt device=/home/azamario/data/wordpress --opt o=bind
	@ docker-compose -f ./src/docker-compose.yml up -d --build 

set_host:
	@ sudo grep -q azamario /etc/hosts || sudo sed -i "3i127.0.0.1\tazamario.42.fr" /etc/hosts

up:
	@ sudo docker-compose -f ./src/docker-compose.yml up --build --detach

down:
	@ sudo docker-compose -f ./src/docker-compose.yml down

fclean: down
	@ docker system prune --all --force --volumes
	@ docker volume rm mariadb_volume wordpress_volume
	@ sudo rm -fr /home/azamario/data

.PHONY: all set_host up down fclean

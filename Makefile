

#create directories and volumes + call docker-compose, but before this, set_host is executed
# --build rebuilds image if necessary
all: set_host
	@ sudo mkdir -p /home/azamario/data/mysql
	@ docker volume create --name mariadb_volume --opt type=none --opt device=/home/azamario/data/mysql --opt o=bind
	@ sudo mkdir -p /home/azamario/data/wordpress
	@ docker volume create --name wordpress_volume --opt type=none --opt device=/home/azamario/data/wordpress --opt o=bind
	@ docker-compose -f ./src/docker-compose.yml up -d --build 

#this target is responsible for modifying the /etc/hosts file to add an entry for azamario.42.fr 
#with IP address 127.0.0.1. This is often used to simulate domain name resolution for local development.
#||: this is the logical OR operator in shell scripting. It allows you to execute the command on its right-hand side 
# only if the command on its left-hand side fails (returns a non-zero exit status).
# "3i127.0.0.1\tazamario.42.fr": this is the actual sed command. It tells sed to insert the string "127.0.0.1\tazamario.42.fr" 
# (where \t represents a tab character) as the third line in the /etc/hosts file. In other words, it adds an entry to map the hostname "azamario.42.fr" 
# to the IP address "127.0.0.1" in the hosts file.
set_host:
	@ sudo grep -q azamario /etc/hosts || sudo sed -i "3i127.0.0.1\tazamario.42.fr" /etc/hosts

up:
	@ sudo docker-compose -f ./src/docker-compose.yml up --build --detach

down:
	@ sudo docker-compose -f ./src/docker-compose.yml down

fclean: down
#Remove all stopped containers, networks, volumes, and images not used by any containers with the --force and --volumes flags to remove volumes as well.
	@ docker system prune --all --force --volumes
	@ docker volume rm mariadb_volume wordpress_volume
	@ sudo rm -fr /home/azamario/data

.PHONY: all set_host up down fclean
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: oldsin <oldsin@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/30 18:42:06 by oldsin            #+#    #+#              #
#    Updated: 2026/01/03 04:03:24 by oldsin           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

CONFIGFILE = ./srcs/docker-compose.yaml
LOGIN = ${USER}

build:
	sudo mkdir -p /home/$(LOGIN)/data/mariadb
	sudo mkdir -p /home/$(LOGIN)/data/wordpress
	docker compose -f $(CONFIGFILE) up -d --build 

status:
	@echo "CONTAINERS STATS: -------"
	@docker ps -a
	@echo "IMAGES STATS: -----------"
	@docker images
	@echo "VOLUMES STATS: ----------"
	@docker volume ls
	@echo "NETWORK STATS: ----------" 
	@docker network ls 

mariadb:
	docker exec -it mariadb bash

wordpress:
	docker exec -it wordpress bash

stop:
	@docker compose -f $(CONFIGFILE) stop 

start:
	@docker compose -f $(CONFIGFILE) start
	
down:
	@docker compose -f $(CONFIGFILE) down --volumes --rmi all
	@docker volume prune -af
	sudo rm -rf  /home/$(LOGIN)/data/mariadb
	sudo rm -rf	 /home/$(LOGIN)/data/wordpress
	
rmi:
	@docker rmi ${shell docker images -q}

restart: stop start

re: down build
	
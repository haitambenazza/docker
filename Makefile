# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: oldsin <oldsin@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/30 18:42:06 by oldsin            #+#    #+#              #
#    Updated: 2026/01/01 18:36:39 by oldsin           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

CONFIGFILE = ./srcs/docker-compose.yaml
LOGIN = ${USER}

build:
	sudo mkdir -p /home/$(LOGIN)/data/mariadb
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

stop:
	@docker compose -f $(CONFIGFILE) stop 

start:
	@docker compose -f $(CONFIGFILE) start
	
down:
	sudo rm -rf /home/$(LOGIN)/data/mariadb
	@docker compose -f $(CONFIGFILE) down -v --rmi all
	

restart: stop start

re: down build
	
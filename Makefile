# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: oldsin <oldsin@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/30 18:42:06 by oldsin            #+#    #+#              #
#    Updated: 2025/12/31 17:32:25 by oldsin           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

CONFIGFILE = ./srcs/docker-compose.yaml

build:
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
	
stop:
	@docker compose -f $(CONFIGFILE) stop 

start:
	@docker compose -f $(CONFIGFILE) start
	
down:
	@docker compose -f $(CONFIGFILE) down -v --rmi all

restart: stop start

re: down build
	
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: oldsin <oldsin@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/30 18:42:06 by oldsin            #+#    #+#              #
#    Updated: 2025/12/31 00:37:56 by oldsin           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DOCKER_LS = $(shell (docker ps -aq))

build:
	docker compose -f ./srcs/docker-compose.yaml up -d

status:
	@echo "CONTAINERS STATS: -------"
	@docker ps -a
	@echo "IMAGES STATS: -----------"
	@docker images
	@echo "VOLUMES STATS: ----------"
	@docker volume ls
	@echo "NETWORK STATS: ----------" 
	@docker network ls 
			
clean:
	@if [ $(DOCKER_LS) ]; then \
		@docker stop $(DOCKER_LS);\
		@docker rm $(DOCKER_LS);\
	fi
	docker compose -f ./srcs/docker-compose.yaml down -v --rmi all

restart:
	
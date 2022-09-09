# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jkong <jkong@student.42seoul.kr>           +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/09/04 05:08:57 by jkong             #+#    #+#              #
#    Updated: 2022/09/10 03:58:22 by jkong            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

TARGET := inception

DATA_PATH := /home/jkong/data/
COMPOSE_PATH := ./srcs/docker-compose.yml
DOCKER_COMPOSE := docker compose -f $(COMPOSE_PATH) -p $(TARGET)

.PHONY: install build up down clean

install:
	apt install curl
	curl -fsSL https://get.docker.com -o get-docker.sh
	sh get-docker.sh

build:
	mkdir -p $(DATA_PATH)db $(DATA_PATH)wp $(DATA_PATH)git
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down -v

clean:
	-docker stop `docker ps -aq`
	-docker rm -fv `docker ps -aq`
	-docker rmi -f `docker images -aq`
	docker system prune -af
	rm -rf $(DATA_PATH)

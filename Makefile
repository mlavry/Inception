NAME := inception
COMPOSE_FILE := srcs/docker-compose.yml
COMPOSE := docker compose -f $(COMPOSE_FILE)

DATA_PATH := /home/$(USER)/data
DB_PATH := $(DATA_PATH)/mariadb
WP_PATH := $(DATA_PATH)/wordpress

all: up

up: directories
	$(COMPOSE) up -d --build

build:
	$(COMPOSE) build

down:
	$(COMPOSE) down

start: 
	$(COMPOSE) start

stop: 
	$(COMPOSE) stop

restart:
	$(COMPOSE) restart

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

directories:
	mkdir -p $(DB_PATH)
	mkdir -p $(WP_PATH)

clean:
	$(COMPOSE) down -v

fclean: clean
	docker system prune -af

re: clean up

.PHONY: all up build down start stop restart logs ps directories clean fclean re

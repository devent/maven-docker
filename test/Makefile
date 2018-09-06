include ../utils/Makefile.help
include ../utils/Makefile.functions

export NAME := archiva
export ROOT_DIR := $(shell realpath ./root)
export NGINX_CONF_DIR := $(shell realpath ./nginx-in)
YAML ?= test.yaml

.PHONY: test
test: setup ##@targets Starts docker compose.
	docker-compose -p $(NAME) -f $(YAML) up

.PHONY: stop
stop: ##@targets Stops test containers.
	docker-compose -p $(NAME) -f $(YAML) stop

.PHONY: rm
rm: stop ##@targets Removes test containers.
	docker-compose -p $(NAME) -f $(YAML) rm -f

.PHONY: clean
clean: rm ##@targets Removes docker containers and created files.
	sudo rm -rf root

.PHONY: setup
setup:
	for p in html db data; do \
	mkdir -p root/$$p; \
	chmod o+rwX root/$$p ; \
	done

.PHONY: test-mysql
test-mysql:
	$(MAKE) YAML=test-mysql.yaml test

.PHONY: stop-mysql
stop-mysql:
	$(MAKE) YAML=test-mysql.yaml stop

.PHONY: rm-mysql
rm-mysql:
	$(MAKE) YAML=test-mysql.yaml rm

.PHONY: clean-mysql
clean-mysql:
	$(MAKE) YAML=test-mysql.yaml clean

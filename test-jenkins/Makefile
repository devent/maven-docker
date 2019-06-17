include ../utils/Makefile.help
include ../utils/Makefile.functions

export NAME := maven
YAML := test.yaml

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
	for p in workspace; do \
	mkdir -p root/$$p; \
	sudo chmod o+rwX root/$$p ; \
	sudo chown 10000.10000 -R root/$$p ; \
	done

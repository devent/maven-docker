REPOSITORY := erwin82
NAME := maven
VERSION ?= v3.5.3-jdk-8-r.5

.PHONY: build
build: _build ##@targets Builds the docker image.

.PHONY: clean
clean: _clean ##@targets Removes the local docker image.

.PHONY: deploy
deploy: _deploy ##@targets Deploys the docker image to the repository.

include ../utils/Makefile.help
include ../utils/Makefile.functions
include ../utils/Makefile.image

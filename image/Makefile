REPOSITORY := erwin82
NAME := maven
VERSION ?= v3.5.3-jdk-8-r1-3

build: _build ##@targets Builds the docker image.
.PHONY: build

clean: _clean ##@targets Removes the local docker image.
.PHONY: clean

deploy: _deploy ##@targets Deploys the docker image to the repository.
.PHONY: deploy

include ../utils/Makefile.help
include ../utils/Makefile.functions
include ../utils/Makefile.image

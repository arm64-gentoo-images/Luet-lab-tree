BACKEND?=docker
CONCURRENCY?=1
LUET?=luet
export ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: all
all: deps build

.PHONY: deps
deps:
	@echo "Installing luet"
	go get -u github.com/mudler/luet
	go get -u github.com/MottainaiCI/mottainai-cli

.PHONY: clean
clean:
	sudo rm -rf build/ *.tar *.metadata.yaml

.PHONY: build
build: clean
	mkdir -p $(ROOT_DIR)/build
	sudo $(LUET) build `cat $(ROOT_DIR)/targets | xargs echo` --destination $(ROOT_DIR)/build --backend $(BACKEND) --concurrency $(CONCURRENCY)

.PHONY: build-all
build-all: clean
	mkdir -p $(ROOT_DIR)/build
	sudo $(LUET) build --all --destination $(ROOT_DIR)/build --backend $(BACKEND) --concurrency $(CONCURRENCY)

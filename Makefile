BACKEND?=docker
CONCURRENCY?=1
CLEAN?=false
LUET?=luet
export ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DESTINATION?=$(ROOT_DIR)/output
TARGET?=targets

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
	sudo $(LUET) build --clean=$(CLEAN) `cat $(ROOT_DIR)/$(TARGET) | xargs echo` --destination $(ROOT_DIR)/build --backend $(BACKEND) --concurrency $(CONCURRENCY)

.PHONY: build-all
build-all: clean
	mkdir -p $(ROOT_DIR)/build
	sudo $(LUET) build --clean=$(CLEAN) --all --destination $(ROOT_DIR)/build --backend $(BACKEND) --concurrency $(CONCURRENCY)

.PHONY: generate
generate:
	luet convert $(OVERLAY) $(DESTINATION)
	LUET_REPO=$(DESTINATION) scripts/sanitize.sh
	LUET_REPO=$(DESTINATION) scripts/create_build.sh
	scripts/gen_kernel_modules.sh

.PHONY: bump-portage
bump-portage:
	scripts/portage_bump.sh

.PHONY: bump-overlay
bump-overlay:
	scripts/overlay_bump.sh

.PHONY: bump-base
bump-base:
	scripts/base_bump.sh

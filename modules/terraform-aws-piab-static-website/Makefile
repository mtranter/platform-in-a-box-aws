.PHONY: check init clean format validate check

OS_NAME = $(shell uname | tr 'A-Z' 'a-z')
TF_DOCS_BINARY ?= $(ROOT_DIR)/utils/docs/$(OS_NAME)/terraform-docs
SHELL := /bin/bash

init:
	@if [ ! -d ".terraform" ]; then terraform init -backend=false; fi

clean:
	rm -rf .terraform

format:
	terraform fmt -check -recursive

docs:
	@$(TF_DOCS_BINARY) markdown . > README.md

validate:	
	$(ROOT_DIR)/scripts/validate.sh

check:
	@$(MAKE) init
	@$(MAKE) format
	@# https://github.com/hashicorp/terraform/issues/28490
	cd ./example && terraform init && terraform validate

publish: check
	@$(ROOT_DIR)/scripts/publish.sh publish $(CURDIR) $(VERSION) 
.PHONY: help lint test clean install

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install Python dependencies
	python3 -m pip install --upgrade pip
	python3 -m pip install -r requirements.txt

lint: ## Run all linting tools
	@echo "Running ansible-lint..."
	ansible-lint .
	@echo "Running yamllint..."
	yamllint .
	@echo "Running markdownlint..."
	markdownlint .

test: ## Run molecule tests
	molecule test

clean: ## Clean up molecule artifacts
	molecule cleanup
	molecule destroy

syntax: ## Check Ansible syntax
	molecule syntax
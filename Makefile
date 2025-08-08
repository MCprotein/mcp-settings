# MCP Docker Compose Manager
# Usage:
#   make up              # Start all MCPs
#   make down            # Stop all MCPs  
#   make up <mcp-name>   # Start specific MCP
#   make down <mcp-name> # Stop specific MCP
#   make up <mcp-name> ENV_FILE=.env.prod  # Start with custom env file

SHELL := /bin/bash

# Environment file path (default: .env, can be overridden)
ENV_FILE ?= .env

# Find all directories with docker-compose.yaml files
MCP_DIRS := $(sort $(patsubst %/,%,$(dir $(wildcard */docker-compose.yaml))))

# Get arguments after the make target (e.g., "excel-mcp-server" in "make up excel-mcp-server")
ARGS := $(wordlist 2,999,$(MAKECMDGOALS))

# If no arguments, use all MCP directories; otherwise use specified ones
ifeq ($(strip $(ARGS)),)
  TARGET_DIRS := $(MCP_DIRS)
else
  TARGET_DIRS := $(ARGS)
endif

# Docker compose project prefix
PROJECT_PREFIX := mcp-

.DEFAULT_GOAL := help
.PHONY: help list up down clean

help: ## Show help
	@echo "Available commands:"
	@echo "  make list            # List all detected MCPs"
	@echo "  make up              # Start all MCPs"
	@echo "  make down            # Stop all MCPs"
	@echo "  make up <mcp-name>   # Start specific MCP"
	@echo "  make down <mcp-name> # Stop specific MCP"
	@echo "  make clean           # Stop all MCPs and remove volumes"
	@echo ""
	@echo "Environment options:"
	@echo "  ENV_FILE=.env.prod   # Use custom environment file"
	@echo ""
	@echo "Examples:"
	@echo "  make up brave-search-mcp"
	@echo "  make up brave-search-mcp ENV_FILE=.env.prod"
	@echo ""
	@echo "Detected MCPs: $(MCP_DIRS)"

list: ## List all detected MCP directories
	@echo "Found MCP directories:"
	@for d in $(MCP_DIRS); do echo "  - $$d"; done

up: ## Start MCPs (all or specified)
	@if [ -z "$(MCP_DIRS)" ]; then \
		echo "No MCP directories found with docker-compose.yaml files"; \
		exit 1; \
	fi
	@for d in $(TARGET_DIRS); do \
		if [ ! -d "$$d" ]; then \
			echo "❌ Directory '$$d' not found"; \
			exit 1; \
		fi; \
		if [ ! -f "$$d/docker-compose.yaml" ]; then \
			echo "❌ No docker-compose.yaml found in '$$d'"; \
			exit 1; \
		fi; \
		proj="$(PROJECT_PREFIX)$$d"; \
		echo "🚀 Starting $$d (project: $$proj) with env file: $(ENV_FILE)"; \
		cd "$$d" && docker compose -p "$$proj" --env-file "../$(ENV_FILE)" up -d --remove-orphans && cd .. & \
	done; wait
	@echo "✅ All specified MCPs are up"

down: ## Stop MCPs (all or specified)
	@if [ -z "$(MCP_DIRS)" ]; then \
		echo "No MCP directories found with docker-compose.yaml files"; \
		exit 1; \
	fi
	@for d in $(TARGET_DIRS); do \
		if [ ! -d "$$d" ]; then \
			echo "❌ Directory '$$d' not found"; \
			continue; \
		fi; \
		if [ ! -f "$$d/docker-compose.yaml" ]; then \
			echo "❌ No docker-compose.yaml found in '$$d'"; \
			continue; \
		fi; \
		proj="$(PROJECT_PREFIX)$$d"; \
		echo "🛑 Stopping $$d (project: $$proj)"; \
		cd "$$d" && docker compose -p "$$proj" down && cd .. & \
	done; wait
	@echo "✅ All specified MCPs are down"

clean: ## Stop all MCPs and remove volumes
	@for d in $(MCP_DIRS); do \
		if [ -f "$$d/docker-compose.yaml" ]; then \
			proj="$(PROJECT_PREFIX)$$d"; \
			echo "🧹 Cleaning $$d (project: $$proj)"; \
			cd "$$d" && docker compose -p "$$proj" down -v && cd .. & \
		fi; \
	done; wait
	@echo "✅ All MCPs cleaned"

# Catch arguments to prevent "No rule to make target" errors
%:
	@:
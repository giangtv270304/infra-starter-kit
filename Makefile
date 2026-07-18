SHELL := /bin/bash

# ============================================================
# Config
# ============================================================
ENVIRONMENTS_DIR := environments
ENV_FILE_DEV     := .env.dev
ENV_FILE_PROD    := .env.prod

TG       := terragrunt
TG_FLAGS :=

# ============================================================
# Helpers
# ============================================================
define run
	set -a && source $(2) && set +a && \
	(cd $(ENVIRONMENTS_DIR)/$(3) && $(TG) $(1) --all $(TG_FLAGS))
endef

define run_unit
	set -a && source $(2) && set +a && \
	(cd $(ENVIRONMENTS_DIR)/$(3)/$(4) && $(TG) $(1) $(TG_FLAGS))
endef

# ============================================================
# Development
# ============================================================
.PHONY: dev-init dev-plan dev-apply dev-destroy dev-output

dev-init:
	$(call run,init,$(ENV_FILE_DEV),development)

dev-plan:
	$(call run,plan,$(ENV_FILE_DEV),development)

dev-apply:
	$(call run,apply,$(ENV_FILE_DEV),development)

dev-destroy:
	@echo "WARNING: This will destroy all development infrastructure!"
	@read -p "Type 'yes' to confirm: " confirm && [ "$$confirm" = "yes" ]
	$(call run,destroy,$(ENV_FILE_DEV),development)

dev-output:
	$(call run,output,$(ENV_FILE_DEV),development)

dev-apply-vpc:
	$(call run_unit,apply,$(ENV_FILE_DEV),development,vpc)

dev-apply-droplet:
	$(call run_unit,apply,$(ENV_FILE_DEV),development,droplet)

# ============================================================
# Production
# ============================================================
.PHONY: prod-init prod-plan prod-apply prod-destroy prod-output

prod-init:
	$(call run,init,$(ENV_FILE_PROD),production)

prod-plan:
	$(call run,plan,$(ENV_FILE_PROD),production)

prod-apply:
	@echo "WARNING: You are about to apply changes to PRODUCTION!"
	@read -p "Type 'yes' to confirm: " confirm && [ "$$confirm" = "yes" ]
	$(call run,apply,$(ENV_FILE_PROD),production)

prod-destroy:
	@echo "WARNING: This will destroy ALL production infrastructure!"
	@read -p "Type 'yes' to confirm: " confirm && [ "$$confirm" = "yes" ]
	$(call run,destroy,$(ENV_FILE_PROD),production)

prod-output:
	$(call run,output,$(ENV_FILE_PROD),production)

prod-apply-vpc:
	$(call run_unit,apply,$(ENV_FILE_PROD),production,vpc)

prod-apply-droplet:
	$(call run_unit,apply,$(ENV_FILE_PROD),production,droplet)

prod-apply-postgres:
	$(call run_unit,apply,$(ENV_FILE_PROD),production,postgres)

prod-apply-valkey:
	$(call run_unit,apply,$(ENV_FILE_PROD),production,valkey)

prod-apply-volume:
	$(call run_unit,apply,$(ENV_FILE_PROD),production,volume)

# ============================================================
# Utilities
# ============================================================
.PHONY: clean fmt help

clean:
	rm -rf .terragrunt-cache

fmt:
	tofu fmt -recursive

help:
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "  Development"
	@echo "  ─────────────────────────────────────"
	@echo "  dev-init            Init all modules"
	@echo "  dev-plan            Plan all modules"
	@echo "  dev-apply           Apply all modules"
	@echo "  dev-destroy         Destroy all modules"
	@echo "  dev-apply-vpc       Apply vpc only"
	@echo "  dev-apply-droplet   Apply droplet only"
	@echo ""
	@echo "  Production"
	@echo "  ─────────────────────────────────────"
	@echo "  prod-init           Init all modules"
	@echo "  prod-plan           Plan all modules"
	@echo "  prod-apply          Apply all modules  [confirmation required]"
	@echo "  prod-destroy        Destroy all modules [confirmation required]"
	@echo "  prod-apply-vpc      Apply vpc only"
	@echo "  prod-apply-droplet  Apply droplet only"
	@echo "  prod-apply-postgres Apply postgres only"
	@echo "  prod-apply-valkey   Apply valkey only"
	@echo "  prod-apply-volume   Apply volume only"
	@echo ""
	@echo "  Utilities"
	@echo "  ─────────────────────────────────────"
	@echo "  clean               Remove .terragrunt-cache"
	@echo "  fmt                 Format all .tf files (tofu fmt -recursive)"
	@echo "  help                Show this help"
	@echo ""

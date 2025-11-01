.PHONY: help ansible-install ansible-ping ansible-apply ansible-update

# Ansible directory
ANSIBLE_DIR := ansible

# Default target - show help
help:
	@echo "Available commands:"
	@echo ""
	@echo "Ansible:"
	@echo "  make ansible-install        - Install Ansible collections from requirements.yml"
	@echo "  make ansible-ping [target]  - Ping all hosts or specific target (e.g., make ansible-ping swarm)"
	@echo "  make ansible-apply          - Apply site.yml to configure all infrastructure"
	@echo "  make ansible-update         - Update package cache and upgrade all packages on all servers"

# Install Ansible collections from requirements.yml
ansible-install:
	cd $(ANSIBLE_DIR) && ansible-galaxy collection install -r collections/requirements.yml

# Apply site.yml playbook to configure all infrastructure
ansible-apply:
	cd $(ANSIBLE_DIR) && ansible-playbook site.yml

# Update all servers - upgrade packages
ansible-update:
	cd $(ANSIBLE_DIR) && ansible-playbook update.yml

# Ping hosts - use first argument as target, default to 'all'
ansible-ping:
	@cd $(ANSIBLE_DIR) && ansible $(if $(filter-out ansible-ping,$@),$(filter-out ansible-ping,$@),$(if $(word 2,$(MAKECMDGOALS)),$(word 2,$(MAKECMDGOALS)),all)) -m ping

# Catch-all target to prevent make from complaining about unknown targets
%:
	@:

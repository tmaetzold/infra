.PHONY: ping help install apply update

# Default target - show help
help:
	@echo "Available commands:"
	@echo "  make install        - Install Ansible collections from requirements.yml"
	@echo "  make ping [target]  - Ping all hosts or specific target (e.g., make ping swarm, make ping scarif-01)"
	@echo "  make apply          - Apply site.yml to configure all infrastructure"
	@echo "  make update         - Update package cache and upgrade all packages on all servers"

# Install Ansible collections from requirements.yml
install:
	ansible-galaxy collection install -r collections/requirements.yml

# Apply site.yml playbook to configure all infrastructure
apply:
	ansible-playbook site.yml

# Update all servers - upgrade packages
update:
	ansible-playbook update.yml

# Ping hosts - use first argument as target, default to 'all'
ping:
	@ansible $(if $(filter-out ping,$@),$(filter-out ping,$@),$(if $(word 2,$(MAKECMDGOALS)),$(word 2,$(MAKECMDGOALS)),all)) -m ping

# Catch-all target to prevent make from complaining about unknown targets
%:
	@:

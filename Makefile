.PHONY: help ansible-install ansible-ping ansible-apply ansible-check ansible-update

ANSIBLE_DIR := ansible

help:
	@echo "Available commands:"
	@echo ""
	@echo "Ansible:"
	@echo "  make ansible-install        - Install Ansible collections from requirements.yml"
	@echo "  make ansible-ping [target]  - Ping all hosts or specific target (e.g., make ansible-ping swarm)"
	@echo "  make ansible-check          - Check what changes would be made by site.yml (dry-run)"
	@echo "  make ansible-apply          - Apply site.yml to configure all infrastructure"
	@echo "  make ansible-update         - Update package cache and upgrade all packages on all servers"

ansible-install:
	cd $(ANSIBLE_DIR) && ansible-galaxy install -r requirements.yml

ansible-check:
	cd $(ANSIBLE_DIR) && ansible-playbook site.yml --check

ansible-apply:
	cd $(ANSIBLE_DIR) && ansible-playbook site.yml

ansible-update:
	cd $(ANSIBLE_DIR) && ansible-playbook update.yml

ansible-ping:
	@cd $(ANSIBLE_DIR) && ansible $(if $(filter-out ansible-ping,$@),$(filter-out ansible-ping,$@),$(if $(word 2,$(MAKECMDGOALS)),$(word 2,$(MAKECMDGOALS)),all)) -m ping

%:
	@:

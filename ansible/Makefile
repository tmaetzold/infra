.PHONY: ping help install

# Default target - show help
help:
	@echo "Available commands:"
	@echo "  make install        - Install Ansible collections from requirements.yml"
	@echo "  make ping           - Ping all hosts"
	@echo "  make ping GROUP=<name> - Ping specific group (e.g., make ping GROUP=swarm)"

# Install Ansible collections from requirements.yml
install:
	ansible-galaxy collection install -r collections/requirements.yml

# Ping all hosts by default
ping:
ifdef GROUP
	ansible $(GROUP) -m ping
else
	ansible all -m ping
endif

# Ansible Infrastructure Configuration

This directory contains Ansible playbooks and inventory for infrastructure management.

## Directory Structure

```
ansible/
├── playbooks/
│   ├── site.yml          # Main configuration playbook
│   ├── update.yml        # Package update playbook
│   ├── env-set.yml       # Set environment variables
│   └── env-unset.yml     # Unset environment variables
├── inventory/
│   └── hosts.yml         # Inventory definition
├── ansible.cfg           # Ansible configuration
└── requirements.yml      # Ansible Galaxy collections
```

## Usage

All playbooks are executed via the `cli` command in the project root:

```bash
# From project root
./cli apply              # Apply main configuration
./cli check              # Dry-run check
./cli update             # Update packages
./cli env set -t swarm -e FOO=bar
./cli env unset -t swarm -e FOO
```

See the main [README.md](../README.md) for complete CLI documentation.

## Playbooks

- **site.yml** - Main configuration playbook for all hosts
- **update.yml** - Update and upgrade packages on all servers
- **env-set.yml** - Set environment variables in `/etc/profile.d/`
- **env-unset.yml** - Remove environment variable files from `/etc/profile.d/`

## Inventory

Hosts are defined in `inventory/hosts.yml`. See that file for group and host configuration.

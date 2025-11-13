# Infrastructure Management CLI

A Click-based CLI for managing infrastructure with Ansible.

## Setup

```bash
# Install Python dependencies and CLI
uv sync

# Install Ansible collections
uv run cli install
# or
./cli install
```

The `cli` command is installed into the virtual environment and can be run with:
- `uv run cli` - Run through uv (doesn't require venv activation)
- `./cli` - Run via symlink (project root)
- `cli` - Direct command (if venv is activated)

## Usage

### Basic Commands

```bash
# Show help
uv run cli --help
./cli --help

# Ping hosts
./cli ping                    # Ping all hosts
./cli ping swarm              # Ping swarm group
./cli ping host1,host2        # Ping specific hosts

# Apply configuration
./cli check                   # Dry-run (check mode)
./cli apply                   # Apply site.yml
./cli apply -e timezone=UTC   # Apply with extra variables

# Update packages
./cli update                  # Update all servers
```

### Environment Variables

Set or unset environment variables on remote hosts:

```bash
# Set environment variables
./cli env set -e FOO=bar                          # Set on all hosts
./cli env set -t swarm -e FOO=bar                 # Set on swarm group
./cli env set -t swarm -e FOO=bar -e BAZ=qux      # Set multiple variables

# Unset environment variables
./cli env unset -e FOO                            # Unset on all hosts
./cli env unset -t swarm -e FOO                   # Unset on swarm group
./cli env unset -t swarm -e FOO -e BAZ            # Unset multiple variables
```

## Project Structure

```
infra/
├── src/infra/
│   ├── __init__.py
│   ├── cli.py                # Main CLI application
│   └── ansible.py            # Ansible playbook execution utilities
├── ansible/
│   ├── playbooks/
│   │   ├── site.yml          # Main configuration playbook
│   │   ├── update.yml        # Package update playbook
│   │   ├── env-set.yml       # Set environment variables
│   │   └── env-unset.yml     # Unset environment variables
│   ├── inventory/
│   │   └── hosts.yml         # Inventory definition
│   └── requirements.yml      # Ansible collections
├── cli-wrapper               # Bash wrapper with relative venv path
├── cli -> cli-wrapper        # Symlink for convenience
├── pyproject.toml            # Python project configuration (uv)
└── uv.lock                   # Dependency lock file
```

## Development

The CLI is built with:
- **Click** - Command-line interface framework
- **Ansible** - Infrastructure automation
- **uv** - Python package manager

The project uses a proper Python package structure with entry points, making the `cli` command available after running `uv sync`.

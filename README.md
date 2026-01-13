# Infrastructure

Personal infrastructure configuration and dotfiles.

## Structure

```
infra/
├── dotfiles/           # Home Manager configurations (Nix flake)
│   ├── flake.nix       # Home Manager flake
│   ├── home/           # Home Manager modules
│   └── nvim/           # Neovim configuration
├── nixos/              # NixOS system configurations
│   ├── flake.nix       # NixOS flake
│   ├── hosts/          # Per-host configurations
│   ├── hardware/       # Hardware-specific configs
│   ├── roles/          # Reusable role modules
│   └── users/          # User configurations
├── services/           # Docker Compose stacks
│   └── stacks/         # Service definitions (traefik, plex, etc.)
└── scripts/            # Utility scripts
```

## Usage

This repo uses [just](https://github.com/casey/just) as a task runner.

```bash
# List all available commands
just --list

# Dotfiles (Home Manager)
just dotfiles switch <profile>    # Switch Home Manager profile

# NixOS
just nixos check [hostname]       # Dry-run configuration
just nixos build [hostname]       # Build and switch configuration
just nixos rebuild                # Rebuild current host
```

## Tools

- **Nix / NixOS** - Declarative system configuration
- **Home Manager** - User environment management
- **just** - Task runner
- **Docker Compose** - Container orchestration for services

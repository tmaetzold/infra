#!/usr/bin/env python3
"""Infrastructure management CLI for Ansible operations."""

import subprocess
import sys
from pathlib import Path

try:
    import click
except ImportError:
    print("Error: Click is not installed.", file=sys.stderr)
    print("Install with: pip install click", file=sys.stderr)
    sys.exit(1)

# Project paths
INFRA_ROOT = Path(__file__).parent.parent.parent  # Go up from src/infra/cli.py to project root
ANSIBLE_DIR = INFRA_ROOT / "ansible"


def run_ansible_command(args, **kwargs):
    """Run an ansible command in the ansible directory."""
    try:
        subprocess.run(args, cwd=ANSIBLE_DIR, check=True, **kwargs)
    except subprocess.CalledProcessError as e:
        sys.exit(e.returncode)


def run_playbook(playbook_name, extra_vars):
    """Run an Ansible playbook with extra variables.

    Args:
        playbook_name: Name of the playbook file
        extra_vars: Dictionary of extra variables to pass
    """
    playbook_path = ANSIBLE_DIR / "playbooks" / playbook_name

    if not playbook_path.exists():
        click.echo(f"Error: Playbook not found at {playbook_path}", err=True)
        sys.exit(1)

    # Build extra vars string
    extra_vars_str = " ".join(f"{k}={v}" for k, v in extra_vars.items())

    cmd = [
        "ansible-playbook",
        str(playbook_path),
        "-e",
        extra_vars_str
    ]

    try:
        subprocess.run(cmd, cwd=ANSIBLE_DIR, check=True)
    except subprocess.CalledProcessError as e:
        sys.exit(e.returncode)


@click.group()
@click.version_option(version='1.0.0', prog_name='infra')
def cli():
    """Infrastructure management CLI for Ansible operations."""
    pass


@cli.command()
def install():
    """Install Ansible collections from requirements.yml."""
    click.echo("Installing Ansible collections...")
    run_ansible_command(["ansible-galaxy", "install", "-r", "requirements.yml"])
    click.secho("✓ Collections installed successfully", fg="green")


@cli.command()
@click.argument('target', default='all')
def ping(target):
    """Ping all hosts or specific target.

    Examples:

        cli ping

        cli ping swarm

        cli ping host1,host2
    """
    click.echo(f"Pinging {target}...")
    run_ansible_command(["ansible", target, "-m", "ping"])


@cli.command()
@click.option('--extra-vars', '-e', multiple=True, help='Extra variables in KEY=VALUE format')
def check(extra_vars):
    """Check what changes would be made by site.yml (dry-run).

    Examples:

        cli check

        cli check -e timezone=UTC
    """
    click.echo("Running dry-run check...")
    cmd = ["ansible-playbook", "playbooks/site.yml", "--check"]

    if extra_vars:
        for var in extra_vars:
            cmd.extend(["-e", var])

    run_ansible_command(cmd)


@cli.command()
@click.option('--extra-vars', '-e', multiple=True, help='Extra variables in KEY=VALUE format')
def apply(extra_vars):
    """Apply site.yml to configure all infrastructure.

    Examples:

        cli apply

        cli apply -e timezone=America/New_York

        cli apply -e var1=value1 -e var2=value2
    """
    click.echo("Applying configuration...")
    cmd = ["ansible-playbook", "playbooks/site.yml"]

    if extra_vars:
        for var in extra_vars:
            cmd.extend(["-e", var])

    run_ansible_command(cmd)
    click.secho("✓ Configuration applied successfully", fg="green")


@cli.command()
def update():
    """Update package cache and upgrade all packages on all servers.

    Examples:

        cli update
    """
    click.echo("Updating all servers...")
    run_ansible_command(["ansible-playbook", "playbooks/update.yml"])
    click.secho("✓ Update completed successfully", fg="green")


@cli.group()
def env():
    """Manage environment variables on remote hosts."""
    pass


@env.command('set')
@click.option('-t', '--target', default='all', help='Target hosts or groups (default: all)')
@click.option('-e', '--env', 'env_vars', multiple=True, required=True,
              help='Environment variable in KEY=VALUE format (can be specified multiple times)')
def env_set(target, env_vars):
    """Set environment variables on hosts.

    Examples:

        cli env set -e FOO=bar

        cli env set -t swarm -e FOO=bar -e BAZ=qux

        cli env set --target swarm --env DOCKER_HOST=unix:///var/run/docker.sock
    """
    for env_var in env_vars:
        if '=' not in env_var:
            click.echo(f"Error: Expected KEY=VALUE, got '{env_var}'", err=True)
            sys.exit(1)

        key, value = env_var.split('=', 1)
        key = key.upper()

        if not key.replace('_', '').isalnum():
            click.echo(f"Error: Invalid variable name '{key}'", err=True)
            click.echo("Use only letters, numbers, and underscores", err=True)
            sys.exit(1)

        click.echo(f"Setting {key}={value} on {target}...")
        run_playbook(
            "env-set.yml",
            {
                "target_hosts": target,
                "env_var": key,
                "env_value": value
            }
        )

    click.secho("✓ Environment variables set successfully", fg="green")


@env.command('unset')
@click.option('-t', '--target', default='all', help='Target hosts or groups (default: all)')
@click.option('-e', '--env', 'env_vars', multiple=True, required=True,
              help='Environment variable name (can be specified multiple times)')
def env_unset(target, env_vars):
    """Unset environment variables on hosts.

    Examples:

        cli env unset -e FOO

        cli env unset -t swarm -e FOO -e BAZ

        cli env unset --target swarm --env DOCKER_HOST
    """
    for var_name in env_vars:
        var_name = var_name.upper()

        if not var_name.replace('_', '').isalnum():
            click.echo(f"Error: Invalid variable name '{var_name}'", err=True)
            click.echo("Use only letters, numbers, and underscores", err=True)
            sys.exit(1)

        click.echo(f"Unsetting {var_name} on {target}...")
        run_playbook(
            "env-unset.yml",
            {
                "target_hosts": target,
                "env_var": var_name
            }
        )

    click.secho("✓ Environment variables unset successfully", fg="green")


if __name__ == '__main__':
    cli()

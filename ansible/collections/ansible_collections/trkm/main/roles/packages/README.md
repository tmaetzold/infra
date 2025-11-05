Trkm.Main Packages Role
========================

Handles package installation, removal, cache updates, and system upgrades on managed hosts.

Requirements
------------

- Ansible 2.9 or higher
- Target hosts running Debian/Ubuntu, RHEL/CentOS, or Arch Linux based distributions
- Sudo privileges on target hosts

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Whether to update package cache
update_cache: true

# Whether to upgrade all packages
update_packages: false

# Whether to autoremove unused packages
update_autoremove: true

# Whether to autoclean package cache (Debian/Ubuntu)
update_autoclean: true

# Packages to install on all distributions
packages: []

# Additional packages to install on Debian/Ubuntu
packages_apt: []

# Additional packages to install on RHEL/CentOS
packages_dnf: []

# Additional packages to install on Arch Linux
packages_pacman: []

# Packages to remove on all distributions
remove_packages: []

# Additional packages to remove on Debian/Ubuntu
remove_packages_apt: []

# Additional packages to remove on RHEL/CentOS
remove_packages_dnf: []

# Additional packages to remove on Arch Linux
remove_packages_pacman: []
```

Dependencies
------------

None.

Example Playbook
----------------

Update cache only (no package changes):

```yaml
- name: Update package cache on all hosts
  hosts: all
  become: true
  roles:
    - role: trkm.main.packages
      update_cache: true
```

Install packages:

```yaml
- name: Install specific packages
  hosts: all
  become: true
  roles:
    - role: trkm.main.packages
      packages:
        - vim
        - git
      packages_apt:
        - software-properties-common
```

Remove packages:

```yaml
- name: Remove unwanted packages
  hosts: all
  become: true
  roles:
    - role: trkm.main.packages
      remove_packages:
        - nano
        - vi
```

Full system upgrade:

```yaml
- name: Update and upgrade all hosts
  hosts: all
  become: true
  roles:
    - role: trkm.main.packages
      update_cache: true
      update_packages: true
```

Use as dependency in another role:

```yaml
# roles/docker/meta/main.yml
---
dependencies:
  - role: trkm.main.packages
```

License
-------

MIT

Author Information
------------------

Trent Maetzold

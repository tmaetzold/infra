Trkm.Main Update Role
========================

Updates package cache and optionally upgrades all packages on managed hosts.

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
```

Dependencies
------------

None.

Example Playbook
----------------

Update cache only (no upgrades):

```yaml
- name: Update package cache on all hosts
  hosts: all
  become: true
  roles:
    - trkm.main.update
```

Update cache and upgrade all packages:

```yaml
- name: Update and upgrade all hosts
  hosts: all
  become: true
  roles:
    - role: trkm.main.update
      update_packages: true
```

Use as dependency in another role:

```yaml
# roles/docker/meta/main.yml
---
dependencies:
  - role: trkm.main.update
```

License
-------

MIT

Author Information
------------------

Trent Maetzold

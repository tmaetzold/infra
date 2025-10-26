Trkm.Main Common Role
========================

Installs common packages and performs basic system configuration on all managed hosts.

Requirements
------------

- Ansible 2.9 or higher
- Target hosts running Debian/Ubuntu, RHEL/CentOS, or Arch Linux based distributions
- Sudo privileges on target hosts

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# List of common packages to install on all hosts
common_packages:
  - vim
  - git
  - curl
  - wget

# Timezone to set on all hosts
common_timezone: "UTC"

# Whether to update package cache
common_update_cache: true
```

You can override these variables in your playbook or inventory group_vars/host_vars files.

Dependencies
------------

None.

Example Playbook
----------------

Basic usage - install default common packages:

```yaml
- name: Configure common packages on all hosts
  hosts: all
  become: true
  roles:
    - role: trkm.main.common
```

With custom package list:

```yaml
- name: Configure common packages with custom list
  hosts: all
  become: true
  roles:
    - role: trkm.main.common
      common_packages:
        - vim
        - git
        - htop
        - python3-pip
        - docker.io
      common_timezone: "America/New_York"
```

Using include_role:

```yaml
- name: Apply common configuration
  hosts: swarm
  become: true
  tasks:
    - name: Include common role
      ansible.builtin.include_role:
        name: trkm.main.common
```

License
-------

MIT

Author Information
------------------

Trent Maetzold

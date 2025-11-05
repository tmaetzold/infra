Trkm.Main Docker Role
======================

Installs Docker Engine and Docker Compose from the official Docker repositories.

Requirements
------------

- Ansible 2.9 or higher
- Target hosts running Debian/Ubuntu, RHEL/CentOS, or Arch Linux based distributions
- Sudo privileges on target hosts
- Internet access to download Docker packages

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Docker packages to install (works for Debian/Ubuntu and RHEL/CentOS)
docker_packages:
  - docker-ce
  - docker-ce-cli
  - containerd.io
  - docker-buildx-plugin
  - docker-compose-plugin

# Docker packages for Arch Linux
docker_packages_pacman:
  - docker
  - docker-compose

# Conflicting packages to remove on Debian/Ubuntu
docker_remove_packages_apt:
  - docker.io
  - docker-doc
  - docker-compose
  - docker-compose-v2
  - podman-docker
  - containerd
  - runc

# Conflicting packages to remove on RHEL/CentOS
docker_remove_packages_dnf:
  - docker
  - docker-client
  - docker-client-latest
  - docker-common
  - docker-engine
  - docker-engine-selinux
  - docker-latest
  - docker-latest-logrotate
  - docker-logrotate
  - docker-selinux
  - podman
  - runc

# Whether to start and enable Docker service
docker_service_enabled: true
docker_service_state: started
```

You can override these variables in your playbook or inventory group_vars/host_vars files.

Dependencies
------------

- **trkm.main.packages** - Handles package installation

Example Playbook
----------------

Basic usage - install Docker with default configuration:

```yaml
- name: Install Docker on hosts
  hosts: docker_hosts
  become: true
  roles:
    - role: trkm.main.docker
```

With custom configuration:

```yaml
- name: Install Docker without starting service
  hosts: docker_hosts
  become: true
  roles:
    - role: trkm.main.docker
      docker_service_enabled: false
```

Using include_role:

```yaml
- name: Setup Docker
  hosts: swarm
  become: true
  tasks:
    - name: Install Docker
      ansible.builtin.include_role:
        name: trkm.main.docker
```

License
-------

MIT

Author Information
------------------

Trent Maetzold

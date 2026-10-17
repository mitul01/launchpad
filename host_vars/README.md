# Host Variables & Machine Profiles (`host_vars/`)

Launchpad supports multi-Macbook configuration management using profile files placed in `host_vars/`.

## Resolution Order

When you run `./bootstrap.sh` or `ansible-playbook -i inventory main.yml`, Launchpad looks for profile variables in the following order (stopping at the first file found):

1. `host_vars/{{ profile }}.yml` (if specified via `-e profile=<name>` or `LAUNCHPAD_PROFILE=<name>`)
2. `host_vars/{{ ansible_facts['hostname'] }}.yml` (matches system hostname automatically)
3. `host_vars/default.yml` (fallback for all machines)

## Creating a Profile

Create a profile file in `host_vars/`:

```bash
# Work machine profile
touch host_vars/work.yml

# Or hostname-based auto-detected profile
touch host_vars/$(hostname -s).yml
```

## Feature Toggles

You can selectively disable or enable modules in your profile:

```yaml
enable_k8s: false
enable_aws: true
enable_containers: true
```

## Overriding Tool Configurations

Override any list or dictionary defined in `vars/*.yml`:

```yaml
gui_casks:
  - sublime-text
  - font-jetbrains-mono-nerd-font
  - slack
  - zoom

fish_environment_vars:
  EDITOR: "code"
  VISUAL: "code"
```

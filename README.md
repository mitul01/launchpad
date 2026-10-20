# Launchpad (`launchpad`)

An idempotent, declarative Ansible-based automation repository for bootstrapping and maintaining macOS development workstations across multiple machines.

## Quick Start (New Mac)

On a brand new Mac (no pre-requisites or git clone required), open Terminal and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mitul01/launchpad/main/bootstrap.sh)"
```

This command automatically:
1. Downloads the Launchpad repository into `~/launchpad`.
2. Installs Xcode Command Line Tools, Homebrew, and Ansible (if missing).
3. Installs required Ansible collections.
4. Executes the setup playbook (`main.yml`).

---

## Category-Based Architecture

Launchpad is organized into clean, domain-specific modules with machine profile support:

```text
launchpad/
├── host_vars/           # Machine profiles & overrides (ignored by git except .example files)
│   ├── README.md
│   ├── work.yml
│   └── personal.yml
│
├── vars/
│   ├── shell.yml        # Fish shell, Fisher plugins, Starship prompt & aliases
│   ├── utility.yml      # Everyday CLI utilities (git, gh, jq, yq, bat, eza, fzf, etc.)
│   ├── gui.yml          # GUI apps & developer fonts (Sublime Text, JetBrainsMono)
│   ├── python.yml       # Python toolchain (uv, ruff, pipx, yawsso, Python versions)
│   ├── node.yml         # Node.js toolchain (fnm, Node versions, pnpm, yarn, typescript)
│   ├── go.yml           # Go toolchain (go, gopls, golangci-lint, air, delve)
│   ├── terraform.yml    # IaC toolchain (tenv, tflint, tfsec, terraform-docs)
│   ├── containers.yml   # Container engines (OrbStack, docker-compose, lazydocker, ctop)
│   ├── k8s.yml          # K8s toolchain (kubectl, helm, k9s, kubectx, krew plugins, argocd)
│   ├── aws.yml          # AWS CLI v2, SSM plugin, 1Password CLI, PropertyGuru SSO profiles
│   ├── antigravity.yml  # Antigravity CLI (agy) installation & setup
│   ├── bitwarden.yml    # Bitwarden CLI (bws) installation
│   └── mcp.yml          # MCP server settings (GitHub, Jira, Confluence, Datadog, Steampipe)
│
├── tasks/
│   ├── terminal_ghostty.yml
│   ├── shell_fish.yml
│   ├── utility.yml
│   ├── gui.yml
│   ├── python.yml
│   ├── node.yml
│   ├── go.yml
│   ├── terraform.yml
│   ├── containers.yml
│   ├── k8s.yml
│   ├── aws.yml
│   ├── antigravity.yml
│   ├── bitwarden.yml
│   └── mcp.yml
│
└── templates/
    ├── fish/config.fish.j2
    ├── ghostty/config.j2
    ├── aws/config.j2
    └── mcp/mcp.json.j2
```

## Local Usage

### 1. Re-running Locally
If you have already cloned the repository locally:
```bash
./bootstrap.sh
```

### 2. Updating Configuration
To apply changes made to playbooks or variables directly:
```bash
ansible-playbook -i inventory main.yml --ask-become-pass
```

---

## Managing Multiple MacBooks (Pull-Based)

Launchpad makes it easy to maintain multiple MacBooks (e.g. Work vs. Personal) using **Machine Profiles** and **Ansible Tags**.

### Machine Profiles (`host_vars/`)

Place machine profiles inside `host_vars/`. Launchpad resolves variables in the following priority order:

1. Specified profile flag: `-e profile=work` or `LAUNCHPAD_PROFILE=work`
2. Hostname auto-match: `host_vars/<hostname>.yml`
3. Fallback: `host_vars/default.yml`

#### Creating a Profile

```bash
# Work machine profile
cp host_vars/work.yml.example host_vars/work.yml

# Personal machine profile
cp host_vars/personal.yml.example host_vars/personal.yml

# Or hostname-based profile (automatically loaded without flags)
cp host_vars/work.yml.example host_vars/$(hostname -s).yml
```

#### Disabling / Enabling Modules in Profiles

Disable tools on specific laptops by setting `enable_<module>: false` in `host_vars/<profile>.yml`:

```yaml
enable_aws: false
enable_k8s: false
enable_terraform: false
```

#### Running a Specific Profile

```bash
# Pass via bootstrap argument
./bootstrap.sh -e profile=work

# Or set via environment variable
LAUNCHPAD_PROFILE=work ./bootstrap.sh
```

---

### Selective Execution with Tags

Filter execution using `--tags` or `--skip-tags`:

```bash
# Run only GUI applications and Fish shell
./bootstrap.sh --tags "gui,shell"

# Skip Kubernetes and Container tools
./bootstrap.sh --skip-tags "k8s,containers"
```

#### Available Tags

| Module | Available Tags |
| :--- | :--- |
| Terminal | `terminal`, `ghostty`, `gui` |
| Shell | `shell`, `fish`, `cli` |
| Utilities | `utility`, `cli` |
| GUI Apps | `gui`, `apps` |
| Python | `python`, `dev`, `cli` |
| Node.js | `node`, `javascript`, `dev`, `cli` |
| Go | `go`, `dev`, `cli` |
| Terraform | `terraform`, `iac`, `dev`, `cli` |
| Containers | `containers`, `docker`, `dev` |
| Kubernetes | `k8s`, `kubernetes`, `dev`, `cli` |
| AWS | `aws`, `cloud`, `cli` |
| Antigravity | `antigravity`, `cli` |
| Bitwarden | `bitwarden`, `cli` |
| MCP | `mcp`, `ai` |

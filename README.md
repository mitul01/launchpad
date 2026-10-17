# Launchpad (`launchpad`)

An idempotent, declarative Ansible-based automation repository for bootstrapping and maintaining a macOS development workstation.

## Category-Based Architecture

Launchpad is organized into clean, domain-specific modules:

```text
launchpad/
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
│   └── mcp.yml
│
└── templates/
    ├── fish/config.fish.j2
    ├── ghostty/config.j2
    ├── aws/config.j2
    └── mcp/mcp.json.j2
```

## Usage

### 1. New Mac Setup
Run the bootstrap script:
```bash
./bootstrap.sh
```

### 2. Updating Configuration
To apply changes made to playbooks or variables:
```bash
ansible-playbook -i inventory main.yml --ask-become-pass
```

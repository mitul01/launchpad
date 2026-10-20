#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo " macOS Setup Bootstrap Script"
echo "=========================================="

# 0. Ensure repository files exist locally if bootstrapped remotely
if [[ ! -f "main.yml" ]]; then
  REPO_DIR="${LAUNCHPAD_DIR:-$HOME/launchpad}"
  echo "Downloading Launchpad repository to ${REPO_DIR}..."
  mkdir -p "$REPO_DIR"
  curl -fsSL https://github.com/mitul01/launchpad/archive/refs/heads/main.tar.gz | tar -xz --strip-components=1 -C "$REPO_DIR"
  cd "$REPO_DIR"
fi

# 1. Ensure Homebrew environment is loaded
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# 2. Install Xcode Command Line Tools if missing
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Please complete the Command Line Tools installation prompt and re-run this script."
  exit 1
fi

# 3. Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# 4. Install Ansible via Homebrew if missing
BREW_PREFIX="$(brew --prefix)"
if ! [[ -f "${BREW_PREFIX}/bin/ansible-galaxy" ]]; then
  echo "Installing Ansible via Homebrew..."
  brew install ansible
fi

ANSIBLE_GALAXY="${BREW_PREFIX}/bin/ansible-galaxy"
ANSIBLE_PLAYBOOK="${BREW_PREFIX}/bin/ansible-playbook"

if ! [[ -f "$ANSIBLE_GALAXY" ]]; then
  ANSIBLE_GALAXY="$(command -v ansible-galaxy)"
fi

if ! [[ -f "$ANSIBLE_PLAYBOOK" ]]; then
  ANSIBLE_PLAYBOOK="$(command -v ansible-playbook)"
fi

# 5. Install Ansible collections from requirements.yml
if [[ -f "requirements.yml" ]]; then
  echo "Installing Ansible collections..."
  "$ANSIBLE_GALAXY" collection install -r requirements.yml
fi

# 6. Run Ansible Playbook
echo "Running Ansible Playbook..."
"$ANSIBLE_PLAYBOOK" -i inventory main.yml --ask-become-pass "$@"

echo "=========================================="
echo " Setup complete!"
echo "=========================================="

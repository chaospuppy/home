# Home
Repo to store my dotfiles and tool configurations for MacOS development environment setup.

## What It Does

This script automates the installation and configuration of:

- **Homebrew** - Package manager for MacOS
- **Development Tools** - git, nvim, tmux, docker, kubectl, helm, terraform-docs, and more
- **Shell Environment** - oh-my-zsh with powerlevel10k theme
- **Terminal** - Alacritty with custom configuration
- **Editor** - NvChad (Neovim configuration)
- **Python** - Global Python 3.12.2 via mise

## Prerequisites

- MacOS
- Internet connection

## Installation

```bash
chmod 755 install.sh && ./install.sh
```

## Post-Installation

1. Restart your terminal or run `exec zsh`
2. Run `p10k configure` to set up powerlevel10k preferences
3. Configured symlinks:
   - `~/.config/nvim` → nvim config
   - `~/.tmux.conf` → tmux config
   - `~/.config/alacritty/alacritty.toml` → alacritty config
   - `~/.zshrc`, `~/.zprofile`, `~/.zlogin` → zsh configs

## Installed Tools

The script installs these tools via Homebrew:
- Core: git, nvim, tmux, tree, htop, gsed, ripgrep, lazygit, jq, yq
- Kubernetes: kubectl, helm, k3s, kube-ps1
- Containers: docker, lima, crane, oras, zarf
- Languages: node, yarn, cargo, rust, mise, gopls
- Cloud: awscli, chainctl
- Dev Tools: alacritty, tree-sitter, terraform-docs, uds, git-credential-manager

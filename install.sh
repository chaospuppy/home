#!/bin/bash

logfile="${HOME}/.home-install.log"

function install_nvchad() {
  # Create symlink for vim configuration
  if [ ! -d $HOME/.config/nvim ]; then
    ln -s ${PWD}/nvim $HOME/.config/nvim
  else
    printf "nvim config exists\n"
  fi
}

function install_tmux() {
  if [ ! -f ${HOME}/.tmux.conf ]; then
    ln -s $PWD/tmux/_tmux.conf ${HOME}/.tmux.conf | tee -a $logfile
  else
    echo "~/.tmux.conf already exists, not replacing"
  fi
}

function install_commands() {
  # Install and update all plugins
  declare -a cmds=(
    "git"
    "nvim"
    "tree"
    "htop"
    "gsed"
    "tmux"
    "kubectl"
    "kube-ps1"
    "docker"
    "lima"
    "yarn"
    "cargo"
    "awscli"
    "chainctl"
    "helm"
    "k3s"
    "oras"
    "rust"
    "terraform-docs"
    "tree-sitter"
    "uds"
    "ripgrep"
    "zarf"
    "crane"
    "lazygit"
    "alacritty"
    "font-meslo-for-powerlevel30k"
    "git-credential-manager"
    "gopls"
    "jq"
    "yq"
    "node"
    "mise"
  )

  # Tap required formula repos
  declare -a formula_repos=(
    "chainguard-dev/tap"
    "defenseunicorns/tap"
    "hashicorp/tap"
  )

  for formula in "${formula_repos[@]}"; do
    echo "tapping $formula"
    brew tap $formula
  done

  for cmd in "${cmds[@]}"; do
    command -v "$cmd" >/dev/null
    if [ $? -ne 0 ]; then
      echo " Missing $cmd - installing\r" | tee -a $logfile
      brew install $cmd
    fi
    printf " Located %s\n" "$cmd"
  done
}

function install_alacritty() {
  mkdir -p ${HOME}/.config/alacritty/
  if [ ! -f ${HOME}/.config/alacritty/alacritty.toml ]; then
    ln -s ${PWD}/alacritty/alacritty.toml ${HOME}/.config/alacritty/alacritty.toml
  fi
}

function install_zsh_preferences() {
  declare -a files=(
    ".zshrc"
    ".zprofile"
    ".zlogin"
  )
  for file in "${files[@]}"; do
    newfile=$(echo $file | gsed -e 's/\./_/g')
    echo $file
    if [ -f ${HOME}/$file ]; then
      mv ${HOME}/$file "${HOME}/$file.old"
    fi
    ln -s ${PWD}/zsh/$newfile ${HOME}/$file
  done
}

function install_ohmyzsh() {
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh - || true
}

function install_powerlevel10k() {
  brew install powerlevel10k
  echo "restart zsh by running 'exec zsh', and then run 'p10k configure' to manually configure p10k preferences"
}

function install_brew {
  command -v "brew" >/dev/null
  if [ $? -ne 0 ]; then
    echo " Missing brew - installing\r" | tee -a $logfile
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  printf " Located brew\n"
  export PATH=$PATH:/opt/homebrew/bin
}

function install_completions {
  mkdir -p ~/.kube/
  mkdir -p ~/.lima/

  kubectl completion zsh >~/.kube/completion.zsh.inc
  limactl completion zsh >~/.lima/completion.zsh.inc
}

function install_global_python {
  mise use -g python@3.12.2
}

install_brew
install_commands
install_nvchad
install_tmux
install_zsh_preferences
install_alacritty
install_ohmyzsh
install_powerlevel10k
install_completions
install_global_python

#!/bin/bash

mkdir -p $HOME/.dotfiles

function install_nvim() {
    # Create sylink for vim configuration
    if [ ! -d $HOME/.dotfiles/vim-config ]; then
        ln -s ${PWD}/vim $HOME/.dotfiles/vim-config
    else
        printf "vim-config exists - no need to copy it\n"
    fi

    # Grab vim-plug
    printf "Installing |vim-plug|...\n"
    curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    mkdir -p $HOME/.vim/colors
    curl -o $HOME/.vim/colors/gruvbox.vim \
        https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim

    # Set up NeoVim Configuration
    mkdir -p $HOME/.config/nvim
    ln -s ${PWD}/vim/init.vim $HOME/.config/nvim 2> /dev/null
    ln -s ${PWD}/vim/settings.json $HOME/.config/nvim  2> /dev/null
}


function install_tmux() {
  if [ ! -f ${HOME}/.tmux.conf ]; then
    ln -s $PWD/tmux/_tmux.conf ${HOME}/.tmux.conf | tee -a $logfile
  else
    echo "~/.tmux.conf already exists, not replacing"
  fi
}

function install_lvim_and_config() {
  LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)
  if [ -f ${HOME}/.config/lvim/config.lua ]; then
    rm ${HOME}/.config/lvim/config.lua
  fi
  ln -s $PWD/lvim/config.lua ${HOME}/.config/lvim/config.lua | tee -a $logfile
}

function install_commands() {
    # Install and update all plugins
    declare -a cmds=(
        "git"
        "nvim"
        "tree"
        "htop"
        "gsed"
        "pyenv"
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
      command -v "$cmd" > /dev/null
      if [ $? -ne 0 ]; then
        echo " Missing $cmd - installing\r" | tee -a $logfile
        brew install $cmd
      fi
      printf " Located %s\n" "$cmd"
    done

    if hash nvim 2>/dev/null; then
        # nvim is installed
        nvim +PlugUpgrade +PlugInstall +PlugUpdate +qa
    else
        printf "You need to install neovim before moving on.\n" | tee -a $logfile
    fi
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
  )
  for file in "${files[@]}"; do
    newfile=$(echo $file | gsed -e 's/\./_/g')
    echo $file
    if [ -f ${HOME}/$file ]; then
      mv ${HOME}/$file "${HOME}/$file.old"
      if [ command gsed -v 1>/dev/null 2>/dev/null ]; then
        ln -s ${PWD}/zsh/$newfile ${HOME}/$file
      else
        ln -s ${PWD}/zsh/$newfile ${HOME}/$file
      fi
    else
      if [ command gsed -v 1>/dev/null 2>/dev/null ]; then
        ln -s ${PWD}/zsh/$newfile ${HOME}/$file
      else
        ln -s ${PWD}/zsh/$newfile ${HOME}/$file
      fi
    fi
  done
}

function install_ohmyzsh() {
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh - || true
}

function install_powerlevel10k() {
  brew install powerlevel10k
  echo "restart zsh by running 'exec zsh', and then run 'p10k configure' to manually configure p10k perferences"
}

function install_brew {
    command -v "brew" > /dev/null
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

  kubectl completion zsh > ~/.kube/completion.zsh.inc
  limactl completion zsh > ~/.lima/completion.zsh.inc
}

function install_languageclient {
  ~/.vim/plugged/LanguageClient-neovim/install.sh
}

function install_global_python {
  pyenv install 3.12.2
}

function install_pip_dependencies {
  declare -a pip_pkgs=(
    "neovim"
    "pynvim"
    "ipython"
  )
  for pkg in "${pip_pkgs[@]}"; do
    echo "installing $pkg with pip"
    pip install $pkg
  done
}

install_brew
install_commands
install_nvim
install_tmux
install_zsh_preferences
install_alacritty
install_ohmyzsh
install_powerlevel10k
install_completions
install_languageclient
install_global_python
install_lvim_and_config

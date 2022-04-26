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

function install_commands() {

    # Install and update all plugins
    declare -a cmds=(
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
    )
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
  if [ ! -f ${HOME}/.config/alacritty/alacritty.yml ]; then
    ln -s ${PWD}/alacritty/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml
  fi
}

function install_zsh_preferences() {
  declare -a files=(
    ".zshrc"
    ".zprofile"
    ".zlogin"
  )
  for file in "${files[@]}"; do
    echo $file
    if [ ! -f ${HOME}/$file ]; then
      if [ command gsed -v 1>/dev/null 2>&1 ]; then
        ln -s ${PWD}/zsh/`echo $file | gsed -e 's/\./_/g'` ${HOME}/$file
      else
        ln -s ${PWD}/zsh/`echo $file | sed -e 's/\./_/g'` ${HOME}/$file
      fi
    else
      echo "${HOME}/$file already exists"
    fi
  done
}

function install_ohmyzsh() {
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh - || true
}

function install_powerlevel10k() {
  brew install romkatv/powerlevel10k/powerlevel10k
  echo "restart zsh by running 'exec zsh', and then run 'p10k configure' to manually configure p10k perferences"
}

install_commands
install_nvim
install_tmux
install_zsh_preferences
install_alacritty
install_ohmyzsh
install_powerlevel10k


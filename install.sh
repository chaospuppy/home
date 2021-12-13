logfile='/tmp/vim-config.log'

mkdir -p $HOME/.dotfiles

function install_nvim() {
    # Create sylink for vim configuration
    if [ ! -d $HOME/.dotfiles/vim-config ]; then
        ln -s ${PWD}/vim $HOME/.dotfiles/vim-config
    else
        printf "vim-config exists - no need to copy it\n" | tee -a $logfile
    fi

    # Grab vim-plug
    printf "Installing |vim-plug|...\n" | tee -a $logfile
    curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | tee -a $logfile

    mkdir -p $HOME/.vim/colors
    curl -o $HOME/.vim/colors/gruvbox.vim \
        https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim | tee -a $logfile

    # Set up NeoVim Configuration
    mkdir -p $HOME/.config/nvim
    ln -s ${PWD}/vim/init.vim $HOME/.config/nvim | tee -a $logfile
    ln -s ${PWD}/vim/settings.json $HOME/.config/nvim | tee -a $logfile
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
    )
    for cmd in "${cmds[@]}";
    do
        command -v "$cmd" > /dev/null || {
            printf " Missing %s - installing\n" | tee -a $logfile
            # Install that ish
            exit 1
        }
        printf " Located %s\n" "$cmd"
    done

    if hash nvim 2>/dev/null; then
        # nvim is installed
        nvim +PlugUpgrade +PlugInstall +PlugUpdate +qa
    else
        printf "You need to install neovim before moving on.\n" | tee -a $logfile
    fi
}

function install_zsh_preferences() {
  declare -a files=(
  ".zshrc"
  ".zprofile"
  ".zlogin"
  )
  for file in "${files[@]}"; do
    if [ ! -f ${HOME}/$file ]; then
      ln -s ${PWD}/zsh/`echo $file | gsed -e 's/\./_/g'` ${HOME}/$file
    else
      echo "${PWD}/zsh/$file already exists"
    fi
  done
}

function main() {
    touch $logfile
    install_commands
    install_nvim
    install_tmux
    install_zsh_preferences
}

main

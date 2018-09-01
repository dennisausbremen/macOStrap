#!/usr/bin/env bash

homebrew_install() {
  echo "Installing homebrew..."
  if [ ! -f /usr/local/bin/brew ]; then
    ruby -e "$(\curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap homebrew/cask-versions
  else
    echo "Homebrew already installed. So far, so good."
  fi
}

whiptail_install() {
  echo "Installing whiptail..."
  if [ ! -f /usr/local/bin/whiptail ]; then
    brew install newt
  else
    # Test whiptail version
    whiptail -v > /dev/null 2>/dev/null
    if [[ $? -ne 0 ]]; then
      brew reinstall newt
    else
      echo "Whiptail already installed. Going on..."
    fi
  fi
}

rvm_install() {
  mkdir -p ~/.rvm/src && cd ~/.rvm/src && rm -rf ./rvm && \
  git clone --depth 1 https://github.com/rvm/rvm.git && \
  cd rvm && ./install
  source ~/.rvm/scripts/rvm
}

zsh_install() {
  # Symlink macOStraps .zshrc to your $HOME
  ln -s $BASEDIR/dotfiles/.zshrc ~/.zshrc

  # Install zsh and zplug
  brew install zsh zplug
  echo
  echo "+––––––––––––––––+"
  echo "| PLEASE NOTICE! |"
  echo "+––––––––––––––––+"
  echo
  echo "We are about to add brews zsh to your /etc/shells and activate zsh for the"
  echo "first time."
  echo "For this we need superuser privileges."
  echo

  # Add brew zsh to /etc/shells and switch default-shell
  if [ ! "grep -Fx $(echo $( which zsh )) /etc/shells" ]; then
    echo "Adding /usr/local/bin/zsh to /etc/shells"
    sudo /bin/sh -c '/usr/local/bin/zsh >> /etc/shells'
  fi

  chsh -s /usr/local/bin/zsh

  # Install fzf fuzzy completion
  brew install fzf && $(brew --prefix)/opt/fzf/install

  exec zsh
}

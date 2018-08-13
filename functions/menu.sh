#!/usr/bin/env bash

set -u

# SETUP VARS
DOTFILEDIR="$BASEDIR/dotfiles"

BREWFILE="$BASEDIR/brew/Brewfile"
CASKFILE="$BASEDIR/cask/Caskfile"

BREW=/usr/local/bin/brew



show_about() {
  whiptail --title "About openHABian and openhabian-config" --msgbox "openHABian Configuration Tool
  \\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.
  \\nThis tool provides a few routines to make your openHAB experience as comfortable as possible. The menu options help with the setup and configuration of your system. Please select a menu entry to learn more.
  \\nVisit the following websites for more information:
  - Git Repo: GIT_REPO_URL" 20 80
}

show_main_menu() {
  choice=$(whiptail --title "Welcome to macOStrap" --menu "\nSelect what you want to do" 0 0 0 --cancel-button Exit --ok-button Execute \
  "About macOStrap"    "Information about the macOStrap tool" \
  "" "" \
  "Terminal" "Install ZSH & ZSH Configs ►"\
  "Apps"      "Select apps to install via brew-cask ►" \
  "Brew Packages"      "Select brew packages ►" \
  "Components & Configs"      "Select additional components & configs to install ►" \
  "" "" \
  "Update macOStrap"      "Update this version of macOStrap [\$TODO]" \
  3>&1 1>&2 2>&3)
  RET=$?
  if [ $RET -eq 1 ] || [ $RET -eq 255 ]; then
    # "Exit" button selected or <Esc> key pressed two times
    echo "Exiting."
    exit 0
  fi

  if [[ "$choice" == "" ]]; then
    true

  elif [[ "$choice" == *"About"* ]]; then
    show_about

  elif [[ "$choice" == *"Terminal"* ]]; then
    additionalCompsConf=$(whiptail --title "Additional Components & Configurations" --menu "\nSelect the components and configs you want to install:\n\n[enter] = install\n[tab] = switch to Buttons / List" 0 0 0 --cancel-button Back --ok-button Install \
    "zsh    "     "Install ZSH, zPlug & .zshrc" \
    "iterm2    "    "Install iTerm2 themes & config"\
    "mac-defaults    "    "Change mac defaults (e.g. show the ~/Library/ Folder)"\
    3>&1 1>&2 2>&3)
    if [ $? -eq 1 ] || [ $? -eq 255 ]; then return 0; fi
    case "$additionalCompsConf" in
      zsh\ *) zsh_install;;
      iterm2\ *) sh "$BASEDIR/mac/iterm2_install.sh";;
      mac\ *) sh "$BASEDIR/mac/mac_install.sh";;
      "") return ;;
      *) whiptail --msgbox "A not supported option was selected (probably a programming error):\\n  \"$additionalCompsConf\"" 8 80 ;;
    esac

  elif [[ "$choice" == *"Apps"* ]]; then
    apps=$(whiptail --separate-output --title "Apps" --checklist "\nSelect the apps you want to install:\n\n[spacebar] = toggle on/off\n[tab] = switch to Buttons / List" 0 0 0 --cancel-button Back --ok-button Install \
      1password "1Password Password Manager" off \
      atom "Atom Text Editor" off \
      bettertouchtool "BetterTouchTool (Window Snapping)" off \
      caffeine "Caffeine (Disable System sleep)" off \
      arduino "Arduino SDK" off \
      cura "Cura Slicer (3D-Printing)" off \
      cyberduck "Cyberduck – Serverbrowser" off \
      docker "Docker Runtime" off \
      google-chrome "Google Chrome (stable)" off \
      google-chrome-canary "Google Chrome (Canary)" off\
      firefox "Firefox (stable)" off \
      firefox-developer-edition "Firefox (Developer-Edition)" off\
      iterm2 "iTerm2 - the better terminal" off \
      intellij-idea "IntelliJ IDEA" off \
      java8 "Java 8" off \
      macdown "MacDown - A MarkDown Editor" off \
      postman "Postman - API Testing Tool" off \
      psequel "pSequel - PostgreSQL Client" off \
      sequel-pro "Sequel Pro - mySQL Client" off \
      slack "Slack" off \
      spotify "Spotify" off \
      vagrant "Vagrant" off \
      virtualbox "VirtualBox – VM Manager" off \
      virtualbox-extension-pack "VirtualBox Extensions" off \
      visual-studio-code "Visual Studio Code" off \
      vlc "VLC - Video Lan Client" off \
    3>&1 1>&2 2>&3)

    # Only write file if something is selected
    if [[ "${#apps}" > 0 ]]; then
      chkRmExistingFile $CASKFILE
      while read -r line; do
        echo -e "$line" >> $CASKFILE
      done <<< "$apps"
      brew cask install $(cat $CASKFILE|grep -v "#")
    fi

    if [ $? -eq 1 ] || [ $? -eq 255 ]; then return 0; fi

  elif [[ "$choice" == *"Brew"* ]]; then
    brewPackages=$(whiptail --separate-output --title "Brew" --checklist "\nSelect the brew packages you want to install:\n\n[spacebar] = toggle on/off\n[tab] = switch to Buttons / List" 0 0 0 --cancel-button Back --ok-button Install \
      autoconf "Automatic configure script builder" off \
      automake "Tool for generating GNU Standards-compliant Makefiles" off \
      curl "Get a file from an HTTP, HTTPS or FTP server" off \
      git "It's git...come on..." off \
      git-flow "Extensions to follow Vincent Driessen's branching model" off \
      mariadb "Drop-in replacement for MySQL" off \
      mas "Mac App Store command-line interface" off \
      maven "Java-based project management" off \
      nvm "Manage multiple Node.js versions" off \
      openssl "SSL/TLS cryptography library" off \
      php "PHP...yeah..." off \
      phpmyadmin "Web interface for MySQL and MariaDB" off \
      sqlite "Command-line interface for SQLite" off \
      ssh-copy-id "Add a public key to a remote machines authorized_keys file" off \
      tmux "Terminal multiplexer" off \
      tree "Display directories as trees (with optional color/HTML output)" off \
      vim "Vi with many additional features" off \
      wget "Internet file retriever" off \
    3>&1 1>&2 2>&3)

    # Only write file if something is selected
    if [[ "${#brewPackages}" > 0 ]]; then
      chkRmExistingFile $BREWFILE
      while read -r line; do
        echo -e "$line" >> $BREWFILE
      done <<< "$brewPackages"
      brew install $(cat $BREWFILE|grep -v "#")
    fi

    if [ $? -eq 1 ] || [ $? -eq 255 ]; then return 0; fi

  elif [[ "$choice" == *"Components"* ]]; then
    additionalCompsConf=$(whiptail --title "Additional Components & Configurations" --menu "\nSelect the components and configs you want to install:\n\n[enter] = install\n[tab] = switch to Buttons / List" 0 0 0 --cancel-button Back --ok-button Install \
    "rvm    "     "Manage multiple Ruby Versions" \
    3>&1 1>&2 2>&3)
    if [ $? -eq 1 ] || [ $? -eq 255 ]; then return 0; fi
    case "$additionalCompsConf" in
      rvm\ *) rvm_install;;
      "") return ;;
      *) whiptail --msgbox "A not supported option was selected (probably a programming error):\\n  \"$additionalCompsConf\"" 8 80 ;;
    esac
  fi
}

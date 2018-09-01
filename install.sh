#!/bin/bash

# Project repo url
GITHUB_REPO_URL="https://github.com/dennisausbremen/macOStrap/"

# Automatically remove temporary directory when exits
trap removeBrewInstallDirs EXIT

function removeBrewInstallDirs() {
  if [[ ! "$(ls -A brew)" ]]; then
    rm -rf brew/
  fi
  if [[ ! "$(ls -A cask)"  ]]; then
    rm -rf cask/
  fi
}

# Check for OS X
PLATFORM='unknown'
unamestr=$( uname )



if [[ "$unamestr" == 'Darwin' ]]; then
    PLATFORM='osx'
else
    echo "Error: $PLATFORM is not supported. Exiting."
    exit 1
fi

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

SETUP_FILE="$BASEDIR/src/$PLATFORM.sh"

if [[ -e $SETUP_FILE ]]
then
  . $SETUP_FILE
else
  echo "Error: Missing setup file. Exiting."
  exit 1
fi


exit 0

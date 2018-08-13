#!/bin/bash

# Include all subscripts
for scripts in $BASEDIR/functions/*.sh; do source "$scripts"; done

clear
# Resize terminal window (hopefully it fits)
printf '\e[8;60;150t'
printf '\e[5t'
cat $BASEDIR/src/logo

echo

# OSX version requirement
SW_VERS=$(sw_vers -productVersion)
if [[ ! $(echo $SW_VERS | egrep '10.(13)')  ]]
then
    echo "The script requires macOS 10.13.X (High Sierra) to run. You are running version $SW_VERS"
    exit 1
fi

# Base Confirm Dialogue
echo
echo "This script will try to setup your system for web development and "
echo "install standard productivity apps."
echo
echo "In the next step you can configure which programs you want to have installed."
echo
echo
echo "+––––––––––––––––+"
echo "| PLEASE NOTICE! |"
echo "+––––––––––––––––+"
echo
echo "The script needs homebrew to work. If you have already installed it. Fine."
echo "If not, it will install it for you."
echo
confirm "Continue?"
CONTINUE=$?

if [[ $CONTINUE -eq 1 ]]; then
    homebrew_install
else

    echo 'Exiting.'
    exit 0

fi

whiptail_install

echo "Creating directories for brew/cask files"

mkChkDir brew
mkChkDir cask

while show_main_menu; do
    true
done

exit 0

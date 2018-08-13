#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

echo "iTerm2 link preferences $BASEDIR"
if [ -f "$BASEDIR/iterm2/com.googlecode.iterm2.plist" ]
then
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$BASEDIR/iterm2"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
  defaults write com.googlecode.iterm2 PinchToChangeFontSizeDisabled -bool true
  defaults write com.googlecode.iterm2 TrimWhitespaceOnCopy -bool false
  defaults write com.googlecode.iterm2 PromptOnQuit -bool false

  echo "Linking complete"
else
  echo "No preference file available at $BASEDIR/iterm2/com.googlecode.iterm2.plist"
fi

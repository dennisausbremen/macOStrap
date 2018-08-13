#!/usr/bin/env bash

# Based heavily on:
# https://github.com/davidosomething/dotfiles/blob/3cb18359f84d55cbd2ae4c1707375d163c0de0f6/mac/defaults

# Exit immediately if a pipeline returns a non-zero status
set -eu

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Close System Preferences if it's open
osascript -e 'tell application "System Preferences" to quit'

#
# System preferences for hardware
#

# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
rm -rf ~/Library/Application\ Support/Dock/desktoppicture.db
sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
sudo ln -s /Library/Desktop\ Pictures/Sierra\ 2.jpg /System/Library/CoreServices/DefaultDesktop.jpg

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Trackpad: disable launchpad pinch with thumb and three fingers
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

# Bluetooth: Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

#
# App preferences
#

# Dashboard: Disable dashboard
defaults write com.apple.dashboard mcx-disabled -boolean YES

# Dashboard: Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Spaces: Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Dock: Hot corners: Top right screen corner → Start Screensaver
defaults write com.apple.dock wvous-tr-corner -int 5
defaults write com.apple.dock wvous-tr-modifier -int 0

# Finder: Show the ~/Library folder
chflags nohidden ~/Library

# Finder: Column view as default
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Finder: Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Finder: Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Finder: Enable text selection in quicklook
defaults write com.apple.finder QLEnableTextSelection -bool true

# Finder: Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Finder: When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Finder: Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

# Finder: Avoid creating .DS_Store files on network volumes (!!!!!!)
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Menu bar: Set date and time format e.g. Sun 11 Aug 16:55
defaults write com.apple.menuextra.clock DateFormat -string "E MMM d HH:mm"

# Messages.app: Disable smart quotes as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Photos: Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Preview: Don't remember open files
defaults write com.apple.Preview NSQuitAlwaysKeepsWindows -bool false

# Safari: Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Safari: Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Safari: Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Safari: Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Safari: Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Safari: Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Safari: Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Text Edit: Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Text Edit: Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Time Machine: Don't ask to use every drive for Time Machine
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Terminal.app: Only use UTF-8 in Terminal
defaults write com.apple.terminal StringEncodings -array 4

# Activity Monitor: Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Activity Monitor: Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Kill affected applications
for app in \
  Dashboard \
  Dock \
  Finder \
  Safari \
  SystemUIServer \
  ; do killall "$app" >/dev/null 2>&1
done

echo "Done. Note that some of these changes require a logout/restart to take effect."


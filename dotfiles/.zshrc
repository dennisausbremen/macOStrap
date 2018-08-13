export ZPLUG_HOME=/usr/local/opt/zplug
# Essential
source $ZPLUG_HOME/init.zsh

# zsh plugins
zplug "modules/git", from:prezto, use:"alias.zsh"
zplug "modules/environment", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/spectrum", from:prezto
zplug "modules/utility", from:prezto
zplug "modules/completion", from:prezto

# zsh-syntax-highlighting must be loaded after executing
# compinit command and sourcing other plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "modules/history-substring-search", from:prezto, defer:2
zplug "mafredri/zsh-async", from:"github", use:"async.zsh"

# prompt
zplug "sindresorhus/pure"

# install any uninstalled plugins
zplug check || zplug install

# Then, source packages and add commands to $PATH
zplug load

#
# Prezto styles
#
zstyle ':prezto:module:utility:ls'    color 'yes'
zstyle ':prezto:module:utility:diff'  color 'yes'
zstyle ':prezto:module:utility:wdiff' color 'yes'
zstyle ':prezto:module:utility:make'  color 'yes'
#
# Completion Styles
#
#fpath=(~/.zsh/fn $fpath)
#
# case insensitive completion
zstyle ':completion:*' group-name ''
zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list \
    '' \
    'm:{a-z}={A-Z}' \
    'l:|=* r:|[.,_-]=* r:|=* m:{a-z}={A-Z}'

# generate descriptions with magic.
zstyle ':completion:*' auto-description 'specify: %d'
# Don't prompt for a huge list, page it!
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Don't prompt for a huge list, menu it!
zstyle ':completion:*' menu select
# color code completion
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"
# Errors format
zstyle ':completion:*:corrections' format '%B%d (errors %e)%b'
#Don't complete stuff already on the line
zstyle ':completion::*:(rm|vi):*' ignore-line true
# Don't complete directory we are already in (../here)
zstyle ':completion:*' ignore-parents parent pwd

# make kill way awesome
zstyle ':completion:*:processes' command 'ps -au$USER -o pid,time,cmd|grep -v "ps -au$USER -o pid,time,cmd"'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)[ 0-9:]#([^ ]#)*=01;30=01;31=01;38'

#
# Shell Options
#

#much more sane umask
umask 022

# Enable completion in "--option=arg"
setopt magic_equal_subst
# Add "/" if completes directory
setopt mark_dirs
# Can search subdirectory in $PATH
setopt path_dirs
# Print exit value if return code is non-zero
setopt print_exit_value
setopt pushd_ignore_dups
setopt pushd_silent
# Improve rm *
setopt rm_star_wait

#
# History Options
#
HISTFILE=~/.history # Where it gets saved

SAVEHIST=100000 # Remember about a years worth of history (AWESOME)
HISTSIZE=100000

# Always append to history
setopt append_history
# Save time stamp
setopt extended_history
# Expand history
setopt hist_expand
# No duplicates in findings
setopt hist_find_no_dups
# Ignore all duplicates
setopt hist_ignore_all_dups
# Ignore duplicates
setopt hist_ignore_dups
# Ignore add history if space
setopt hist_ignore_space
# Ignore history (fc -l) command in history
setopt hist_no_store
# Reduce spaces
setopt hist_reduce_blanks
# Don't save duplicates
setopt hist_save_no_dups
# When using a hist thing, make a newline show the change before executing it.
setopt hist_verify
# share history between multiple shells
setopt share_history

#
# Functions
#

#
# Create a new directory and cd into it
# Similar to "mkdir xxx && cd $_"
#
mcd() {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

#
# Aliases
#

# Just some useful aliases...
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'

alias brewsky='brew update && brew upgrade && brew prune && brew cleanup && brew doctor'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

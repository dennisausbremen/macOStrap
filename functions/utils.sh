#!/usr/bin/env bash
confirm() {
    read -p "$1 ([y]es or [n]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) return 1 ;;
        *)     return 0 ;;
    esac
}

mkChkDir() {
  if [ ! -d "$BASEDIR/$1/" ]; then
    mkdir "$BASEDIR/$1"
  fi
}

chkRmExistingFile() {
  if [ -f "$1" ]; then
    echo "$1"
    rm -f "$1"
  fi
}

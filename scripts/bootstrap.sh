#!/usr/bin/env bash
#
# bootstrap installs things

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

set -e

echo ''

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

setup_npmrc () {
    info 'setup npmrc'
    user ' - Where should npm install global packages?'
    read -e npm_prefix
    echo "prefix=$npm_prefix" > "$HOME/.npmrc"
    success 'npmrc'
}

setup_zshrc () {
    info 'setup zshrc'
    zshrc=$(cat <<EOF
# Generated zshrc file; DO NOT EDIT
#
# This file tests for a Nix-installed 'zshrc' command and runs it.
if (( \$+commands[zshrc] )); then \$(zshrc); fi
EOF
            )
    echo "$zshrc" > "$HOME/.zshrc"
    success 'zshrc'
}

setup_zshenv () {
    info 'setup zshenv'
    zshenv=$(cat <<EOF
# Generated zshenv file; DO NOT EDIT
#
# This file initializes Nix. This cannot be done in a Nix-derived
# '.zshrc' file, because Nix commands must be present on the PATH environment
# variable.
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
   . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
EOF
          )
    echo "$zshenv" > "$HOME/.zshenv"
    success 'zshenv'
}

# setup_npmrc
# setup_zshrc
setup_zshenv

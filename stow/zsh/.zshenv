# Generated .zshenv file; do not edit
#
# This .zshenv file initializes Nix
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

export EDITOR=emacsclient
export VISUAL=emacsclient

# Keep PATH and path unique
typeset -U -g PATH path

# Generated .zprofile file; do not edit
#
# This .zprofile file initializes Nix
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Keep PATH and path unique
typeset -U -g PATH path

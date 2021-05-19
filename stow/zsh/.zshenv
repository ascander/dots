# Symlinked '.zshenv' file; do not edit

# Initialize Nix
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Set editor
export EDITOR="vim"
export VISUAL="vim"

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Nix-based macOS dotfiles using nix-darwin and home-manager. Single-host configuration for `adost-ltmvznn` (Apple Silicon).

## Commands

```bash
# Build the configuration (required after any changes)
nix build .#darwinConfigurations.adost-ltmvznn.system 

# Apply the configuration (admin privileges required on macOS)
sudo ./result/sw/bin/darwin-rebuild switch --flake .

# Update all flake inputs
nix flake update

# Update specific input (e.g., nixpkgs, darwin, home-manager, neovim-nightly)
nix flake lock --update-input {input}

# Garbage collection (both required for multi-user Nix)
nix-garbage-collect -d
sudo ./result/sw/bin/nix-collect-garbage -d
```

## Architecture

```
flake.nix           # Entry point: inputs (nixpkgs, darwin, home-manager, neovim-nightly)
                    # and single darwinConfiguration

darwin/             # System-level nix-darwin modules
  bootstrap.nix     # Nix settings, experimental features, trusted users
  defaults.nix      # macOS system preferences (dock, trackpad, keyboard)
  homebrew.nix      # Casks, Mac App Store apps, taps
  configuration.nix # Module loader

home/               # User environment via home-manager
  home.nix          # ZSH, git, neovim, tmux, packages, XDG symlinks

config/             # Application configs symlinked via XDG
  ghostty/          # Terminal (theme, cursor shaders)
  starship/         # Shell prompt
  tmux/             # Multiplexer config
  karabiner/        # Keyboard remapping
  amethyst/         # Tiling window manager
  gh/               # GitHub CLI
  fd/               # File finder ignores
  delta/            # Git diff themes

scripts/            # Shell scripts packaged as derivations
  session.sh        # Tmux session manager (fuzzy project picker)
```

## Key Patterns

- All darwin modules are composed in `flake.nix` via `darwinModules`
- Application configs live in `config/` and are symlinked to XDG locations via `home.nix`
- Packages are declared in `home.nix` under `home.packages`
- Homebrew casks (GUI apps not in nixpkgs) are managed in `darwin/homebrew.nix`
- Shell scripts in `scripts/` become packages via `pkgs.writeShellScriptBin`

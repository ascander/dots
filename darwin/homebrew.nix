{ config, lib, ... }:
let
  inherit (lib) mkIf;
  brewEnabled = config.homebrew.enable;
in
{
  homebrew.enable = true;
  homebrew.global.brewfile = true;
  homebrew.onActivation.cleanup = "zap";

  # Disable homebrew auto-updating itself and formulae when called manually.
  # Homebrew formulae are only upgraded during nix-darwin system activation,
  # after running `brew update` explicitly.
  #
  # See: https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.global.autoUpdate
  homebrew.global.autoUpdate = false;
  homebrew.onActivation.autoUpdate = false;
  homebrew.onActivation.upgrade = true;

  homebrew.taps = [
    "homebrew/bundle"
    "nrlquaker/createzap"
  ];

  # Prefer applications from the Mac App Store
  homebrew.masApps = {
    Slack = 803453959;
    "Things 4" = 904280696;
  };

  # Use Homebrew Casks for applications not available in the Mac App Store
  #
  # Note: apps installed via Homebrew are Spotlight-indexed, whereas those
  # installed via nix-darwin or home-manager are not, by default.
  homebrew.casks = [
    "1password"
    "alacritty"
    "amethyst"
    "arc"
    "karabiner-elements"
    "obsidian"
    "signal"
    "spotify"
  ];

  # A last resort; for packages that aren't available (or broken) in `nixpkgs`
  homebrew.brews = [
    "neovim"
    "poetry"
    "pyenv"
  ];
}


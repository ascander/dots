{ config, lib, ... }:
let
  inherit (lib) mkIf;
  brewEnabled = config.homebrew.enable;
in
{
  environment.shellInit = mkIf brewEnabled ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';

  homebrew.enable = true;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;

  homebrew.taps = [
    "homebrew/bundle"
    "homebrew/cask"
    "homebrew/core"
    "nrlquaker/createzap"
  ];

  # Prefer applications from the Mac App Store
  homebrew.masApps = {
  };

  # Use Homebrew Casks for applications not available in the Mac App Store
  #
  # Note: apps installed via Homebrew are Spotlight-indexed, whereas those
  # installed via nix-darwin or home-manager are not, by default.
  homebrew.casks = [
    "alacritty"
  ];

  # A last resort; for packages that aren't available (or broken) in `nixpkgs`
  homebrew.brews = [
    "poetry"
    "pyenv"
  ];
}


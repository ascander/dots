{
  config,
  lib,
  ...
}: {
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
    "nrlquaker/createzap"
  ];

  # Mac App Store apps (via mas)
  #
  # Note: mas is flaky under sudo, which nix-darwin requires for activation.
  # Prefer casks when available. Only use masApps for apps without cask equivalents.
  homebrew.masApps = {
    "Things 4" = 904280696;
  };

  # Use Homebrew Casks for applications not available in the Mac App Store
  #
  # Note: apps installed via Homebrew are Spotlight-indexed, whereas those
  # installed via nix-darwin or home-manager are not, by default.
  homebrew.casks = [
    "amethyst"
    "arc"
    "docker-desktop"
    "font-inter"
    "font-literata"
    "font-monaspace"
    "ghostty"
    "karabiner-elements"
    "obsidian"
    "signal"
    "slack"
    "spotify"
    "whatsapp"
  ];

  # A last resort; for packages that aren't available (or broken) in `nixpkgs`
  homebrew.brews = [];
}

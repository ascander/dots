{ pkgs, lib, ... }:
{
  # Nix configuration
  nix.settings = {
    trusted-users = [ "@admin" ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    # Recommended when using `direnv` etc.
    keep-derivations = true;
    keep-outputs = true;
  };

  # Enable configuration for `nixbld` group and users
  nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service
  services.nix-daemon.enable = true;

  # Add shells installed by nix to `/etc/shells`
  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];

  # Install and setup ZSH to work with nix(-darwin)
  programs.zsh.enable = true;

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    alacritty
  ];

  # Fonts
  # NOTE: this removes any manually added fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = ["FiraMono"]; })
    source-sans-pro
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

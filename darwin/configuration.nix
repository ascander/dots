{ config, lib, pkgs, ... }: {
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
    unstable.alacritty
  ];

  # Nix-darwin does not link installed applications to the user environment.
  # This means apps will not show up in spotlight, and when launched through
  # the dock they come with a terminal window. This is a workaround.
  # Upstream issue: https://github.com/LnL7/nix-darwin/issues/214
  system.activationScripts.applications.text = lib.mkForce ''
    echo "setting up /Applications/Nix Apps" >&2
    nix_apps="/Applications/Nix Apps"

    # Delete the directory to remove old links
    rm -rf "$nix_apps"
    mkdir -p "$nix_apps"

    find ${config.system.build.applications}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read src; do
        # Spotlight does not recognize symlinks, it will ignore directory we
        # link to the applications folder. It does understand MacOS aliases
        # though, a unique filesystem feature. Sadly they cannot be created
        # from bash (as far as I know), so we use the oh-so-great Apple Script
        # instead.
        /usr/bin/osascript -e "
            set fileToAlias to POSIX file \"$src\"
            set applicationsFolder to POSIX file \"$nix_apps\"
            tell application \"Finder\"
                make alias file to fileToAlias at applicationsFolder
                # This renames the alias; 'mpv.app alias' -> 'mpv.app'
                set name of result to \"$(rev <<< "$src" | cut -d'/' -f1 | rev)\"
            end tell
        " 1>/dev/null
      done
  '';

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

{ config, lib, pkgs, ... }:
{
  home.stateVersion = "22.11";

  # Dotfiles
  # TODO: re-evaluate
  xdg.configFile."karabiner/karabiner.json".source = ../config/karabiner/karabiner.json;
  xdg.configFile."iTerm2/com.googlecode.iterm2.plist".source = ../config/iTerm2/com.googlecode.iterm2.plist;

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Packages
  home.packages = with pkgs; [
    unstable.starship
  ];
}

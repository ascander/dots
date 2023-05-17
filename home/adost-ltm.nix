{ config, lib, pkgs, ... }:
{
  home.stateVersion = "22.11";

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Packages
  home.packages = with pkgs; [
    cowsay
  ];
}

{ config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  nixConfigDir = "/Users/adost/code/dots";
in
{
  # Dotfiles
  # Changes to any of these files requires regeneration of the home environment
  xdg.configFile."karabiner/karabiner.json".source = ../config/karabiner/karabiner.json;
  xdg.configFile."fd/ignore".source = ../config/fd/ignore;
  xdg.configFile."direnv/direnvrc".source = ../config/direnv/direnvrc;

  # Dotfiles (unstable)
  # Changes to any of these files does not require regeneration of the home environment
  xdg.configFile."alacritty/alacritty.yml".source = mkOutOfStoreSymlink "${nixConfigDir}/config/alacritty/alacritty.yml";
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "${nixConfigDir}/config/nvim";
}

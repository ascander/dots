{ pkgs }:

let
  emacsBase = pkgs.emacsUnstable; # Emacs 27.1
  emacsWithPackages = (pkgs.emacsPackagesGen emacsBase).emacsWithPackages;
in
emacsWithPackages (epkgs: (
  with epkgs.melpaPackages; [
    use-package
    general
    evil
    evil-collection
    exec-path-from-shell
    osx-trash
    no-littering
    default-text-scale
    vterm
    solarized-theme
    doom-themes
    moody
    minions
    ignoramus
    ace-window
  ]
) ++ (
  with epkgs.elpaPackages; [
  ]
) ++ (
  with epkgs.orgPackages; [
  ]
))

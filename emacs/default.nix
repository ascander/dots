{ pkgs }:

let
  emacsBase = pkgs.emacsUnstable; # Emacs 27.1
  emacsWithPackages = (pkgs.emacsPackagesGen emacsBase).emacsWithPackages;
in
emacsWithPackages (epkgs: (
  with epkgs.melpaPackages; [
    vterm
  ]
) ++ (
  with epkgs.elpaPackages; [
  ]
) ++ (
  with epkgs.orgPackages; [
  ]
))

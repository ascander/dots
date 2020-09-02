{ sources ? import ./sources.nix }:

let
  overlay = self: super:
    {
      niv = import sources.niv {};
      inherit sources;
    };

  emacs-overlay = import sources.emacs-overlay;
in
import sources.nixpkgs
  { overlays = [ overlay emacs-overlay ]; config = {}; }

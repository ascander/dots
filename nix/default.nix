{ sources ? import ./sources.nix }:

let
  overlay = self: super:
    {
      niv = import sources.niv {};
      inherit sources;
    };
in
import sources.nixpkgs
  { overlays = [ overlay ]; config = {}; }

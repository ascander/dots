{ stdenv, fetchgit, src }:

stdenv.mkDerivation rec {
  name = "dircolors-solarized";
  inherit src;

  phases = [ "unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p "$out/share/zsh/dircolors-solarized"
    cp "dircolors.256dark" "$out/share/zsh/dircolors-solarized/dircolors.256dark"
    cp "dircolors.ansi-dark" "$out/share/zsh/dircolors-solarized/dircolors.ansi-dark"
    cp "dircolors.ansi-light" "$out/share/zsh/dircolors-solarized/dircolors.ansi-light"
    cp "dircolors.ansi-universal" "$out/share/zsh/dircolors-solarized/dircolors.ansi-universal"
  '';
}

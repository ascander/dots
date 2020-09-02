{ stdenv, fetchgit, src }:

stdenv.mkDerivation rec {
  name = "zsh-pure-prompt";
  inherit src;

  installPhase = ''
    mkdir -p "$out/share/zsh/site-functions/"
    cp "pure.zsh" "$out/share/zsh/site-functions/prompt_pure_setup"
    cp "async.zsh" "$out/share/zsh/site-functions/async"
  '';
}

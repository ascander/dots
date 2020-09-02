# Git, with a git config baked in (see ./config/git/config)
#
# Adapted from https://github.com/nmattia/homies/blob/master/git/default.nix
{ git, symlinkJoin, makeWrapper }:

symlinkJoin {
  name = "git";
  buildInputs = [ makeWrapper ];
  paths = [ git ];
  postBuild = ''
      wrapProgram "$out/bin/git" \
      --set XDG_CONFIG_HOME "${./config}"
    '';
}

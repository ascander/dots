# fd with global ignore baked in
{ fd, symlinkJoin, makeWrapper }:
symlinkJoin {
  name = "fd";
  buildInputs = [ makeWrapper ];
  paths = [ fd ];
  postBuild = ''
    wrapProgram "$out/bin/fd" \
    --set XDG_CONFIG_HOME "${./config}"
    '';
}


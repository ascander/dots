# alacritty with a wrapped config
{ alacritty, symlinkJoin, makeWrapper }:
symlinkJoin {
  name = "alacritty";
  buildInputs = [ makeWrapper ];
  paths = [ alacritty ];
  postBuild = ''
    wrapProgram "$out/bin/alacritty" \
    --set XDG_CONFIG_HOME "${./config}"
  '';
}

# Tmux with ./tmux.conf baked in
# Copied from https://github.com/nmattia/homies/blob/master/tmux/default.nix
{ tmux, stdenv, symlinkJoin, makeWrapper, tmuxPlugins, writeTextFile }:
let
  # Copy/yank behavior for MacOS
  darwinConf =
    if stdenv.isDarwin then ''
      unbind-key -T copy-mode-vi Enter; bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      set -g @fingers-copy-command 'pbcopy'
    ''
    else "";

  # Manually install tmux-fingers and nord-tmux
  extraConf = darwinConf + ''
    run-shell ${tmuxPlugins.fingers}/share/tmux-plugins/fingers/tmux-fingers.tmux
    run-shell ${tmuxPlugins.nord}/share/tmux-plugins/nord/nord.tmux
  '';

  baseConf = builtins.readFile ./tmux.conf;

  tmuxConfFile = writeTextFile {
    name = "tmux.conf";
    text = ''
      ${baseConf}
      ${extraConf}
    '';
  };
in
  symlinkJoin {
    name = "tmux";
    buildInputs = [ makeWrapper ];
    paths = [ tmux ];
    postBuild = ''
      mkdir -p $out/conf
      ln -s ${tmuxConfFile} $out/conf/tmux.conf
      wrapProgram "$out/bin/tmux" \
      --add-flags "-f $out/conf/tmux.conf"
    '';
  }

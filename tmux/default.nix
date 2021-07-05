# Tmux, with a set of extra plugins and custom config bundled.
{ tmux
, stdenv
, symlinkJoin
, makeWrapper
, powerline
, tmuxPlugins
, writeTextFile
}:
let
  # Copy/yank behavior for MacOS
  darwinConf =
    if stdenv.isDarwin then ''
      unbind-key -T copy-mode-vi Enter; bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      set -g @fingers-copy-command 'pbcopy'
    ''
    else "";

  # Note: since the location of 'tmux.conf' changes every generation, we have
  # to find out what it is in order to activate color themes. You can do this
  # manually with: 
  #
  #   cat $(which tmux)
  #
  # and running '<prefix>:source-file' on the relevant path.
  extraConf = darwinConf + ''
    run-shell ${tmuxPlugins.fingers}/share/tmux-plugins/fingers/tmux-fingers.tmux
    run-shell ${tmuxPlugins.tmux-colors-solarized}/share/tmux-plugins/tmuxcolors/tmuxcolors.tmux

    source ${powerline}/share/tmux/powerline.conf
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

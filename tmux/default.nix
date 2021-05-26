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

  # Note: since the location of 'tmux.conf' changes every generation, we have
  # to find out what it is in order to activate color themes. You can do this
  # manually with: 
  #
  #   less ${HOME}/.nix-profile/bin/tmux
  #
  # and running '<prefix>:source-file' on the path to the latest 'tmux.conf'.
  # This is annoying, but less painful than wrapping my head around how to
  # dynamically generate a binding to sourcing the current 'tmux.conf' and
  # writing it to that same 'tmux.conf'
  extraConf = darwinConf + ''
    run-shell ${tmuxPlugins.fingers}/share/tmux-plugins/fingers/tmux-fingers.tmux
    run-shell ${tmuxPlugins.onedark-theme}/share/tmux-plugins/onedark-theme/tmux-onedark-theme.tmux
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

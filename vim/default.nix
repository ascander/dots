# Vim, with a set of extra packages and a custom vimrc (see ./vimrc) bundled.
{ bash-language-server
, makeWrapper
, metals
, neovim
, nodejs
, rnix-lsp
, symlinkJoin
, vimPlugins
, writeText
}:
let
  dynamicRc = ''
    let g:coc_node_path='${nodejs}/bin/node'
  '';

  coc-settings = import ./coc-nvim/coc-settings.nix {
    inherit bash-language-server metals rnix-lsp;
  };

  coc-settings-file = writeText "coc-settings.json" (builtins.toJSON coc-settings);

  neovim-unwrapped = neovim.override {
    vimAlias = false;
    configure = {
      customRC = dynamicRc + "\n" + builtins.readFile ./vimrc;
      packages.myVimPackage = with vimPlugins; {
        start = [
          coc-nvim
          fzf-vim
          fzfWrapper
          nerdcommenter
          nord-vim
          rainbow
          tabular
          vim-airline
          vim-easy-align
          vim-easymotion
          vim-fugitive
          vim-markdown
          vim-markdown-composer
          vim-nix
          vim-scala
          vim-surround
          vim-tmux-navigator
          vim-toml
        ];
      };
    };
  };
in
symlinkJoin {
  name = "nvim";
  buildInputs = [ makeWrapper ];
  paths = [ neovim-unwrapped ];
  postBuild = ''
    mkdir -p $out/conf
    cp ${coc-settings-file} $out/conf/coc-settings.json
    wrapProgram "$out/bin/nvim" \
      --set VIMCONFIG "$out/conf"
    makeWrapper "$out/bin/nvim" "$out/bin/vim"
  '';
}

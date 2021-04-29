# Vim, with a set of extra packages and a custom vimrc (see ./vimrc) bundled.
{ symlinkJoin
, makeWrapper
, neovim
, vimPlugins
}:
let
  neovim-unwrapped = neovim.override {
    vimAlias = false;
    configure = {
      customRC = builtins.readFile ./vimrc;
      packages.myVimPackage = with vimPlugins; {
        start = [
                nord-vim
                fzf-vim
                fzfWrapper
                markdown-preview
                rainbow
                tabular
                vim-airline
                vim-fugitive
                vim-markdown
                vim-nix
                vim-scala
                vim-surround
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
      wrapProgram "$out/bin/nvim" \
        --set VIMCONFIG "$out/conf"
      makeWrapper "$out/bin/nvim" "$out/bin/vim"
    '';
  }


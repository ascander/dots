# Vim, with a set of extra packages and a custom vimrc (see ./vimrc) bundled.
{ makeWrapper
, neovim
, symlinkJoin
, vimPlugins
}:
let
  neovim-unwrapped = neovim.override {
    vimAlias = false;
    configure = {
      customRC = builtins.readFile ./init.vim;
      packages.myVimPackage = with vimPlugins; {
        start = [
          lualine-nvim
          vim-fugitive
          vim-tmux-navigator
          telescope-nvim
          NeoSolarized
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
    makeWrapper "$out/bin/nvim" "$out/bin/vim"
  '';
}

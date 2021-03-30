# Vim, with a set of extra packages (extraPackages) and a custom vimrc (./vimrc) bundled.
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
	        vim-airline
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


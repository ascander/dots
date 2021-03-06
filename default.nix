{ sources ? import ./nix/sources.nix }:
let
  # Non-specific overlay for things like pinned versions, or unstable packages
  cherries = self: super:
    {
      niv = import sources.niv {};
      pkgs-unstable = import sources.nixpkgs-unstable {};
      pinentry = if (super.stdenv.isDarwin) then super.pinentry_mac else super.pinentry;

      inherit (self.pkgs-unstable) iosevka-bin starship metals neovim powerline;

      nodePackages =
        super.nodePackages // {
          inherit (self.pkgs-unstable.nodePackages) bash-language-server;
        };

      vimPlugins =
        super.vimPlugins // {
          inherit (self.pkgs-unstable.vimPlugins) vim-markdown-composer NeoSolarized;
        };

      tmuxPlugins =
        super.tmuxPlugins // {
          inherit (self.pkgs-unstable.tmuxPlugins) fingers tmux-colors-solarized;
        };
    };

  # User-specific overlay for customizations, such as wrapped configuration, etc.
  customized = self: super:
    {
      custom = {
        fd = self.callPackage ./fd { inherit (super) fd; };
        git = self.callPackage ./git { inherit (super) git; };
        iosevka = super.iosevka-bin.override { variant = "ss08"; };
        tmux = self.callPackage ./tmux { inherit (super) tmux; };
        zshrc = self.callPackage ./zshrc {};

        vim = self.callPackage ./vim {
          inherit (self.nodePackages) bash-language-server;
        };
      };
    };

  pkgs = import sources.nixpkgs {
    overlays = [ cherries customized ];
    config = {};
  };

  # The list of packages to be installed
  packages =
    with pkgs;
    with custom;
    [
      # Customized packages
      fd
      git
      iosevka
      metals
      pinentry
      powerline
      starship
      tmux
      vim
      zshrc

      # Vernilla packages
      pkgs.bash
      pkgs.cacert
      pkgs.coreutils
      pkgs.fasd
      pkgs.fzf
      pkgs.gawk
      pkgs.gitAndTools.gh
      pkgs.gnupg
      pkgs.httpie
      pkgs.iosevka-bin
      pkgs.jq
      pkgs.less
      pkgs.niv.niv
      pkgs.nix
      pkgs.nix-zsh-completions
      pkgs.nodejs-12_x
      pkgs.openjdk
      pkgs.reattach-to-user-namespace
      pkgs.ripgrep
      pkgs.rnix-lsp
      pkgs.sourceHighlight
      pkgs.stow
      pkgs.tree
      pkgs.zsh-completions
      pkgs.zsh-syntax-highlighting
    ];
in
if pkgs.lib.inNixShell
then pkgs.mkShell
  {
    buildInputs = packages;
    shellHook = ''$(zshrc)'';
  }
else packages

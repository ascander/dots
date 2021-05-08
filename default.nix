{ sources ? import ./nix/sources.nix }:
let
  # Non-specific overlay for things like pinned versions, or unstable packages
  cherries = self: super:
    {
      niv = import sources.niv {};
      pkgs-unstable = import sources.nixpkgs-unstable {};
      pinentry = if (super.stdenv.isDarwin) then super.pinentry_mac else super.pinentry;

      inherit (self.pkgs-unstable) iosevka-bin starship metals;

      nodePackages = super.nodePackages // {
        bash-language-server = self.pkgs-unstable.nodePackages.bash-language-server;
      };

      vimPlugins =
        with self.vimUtils;
        super.vimPlugins // {
          markdown-preview = self.callPackage ./vim/markdown-preview {
            inherit buildVimPluginFrom2Nix;
            src = sources.markdown-preview-nvim;
          };
        };

      tmuxPlugins =
        super.tmuxPlugins // {
          inherit (self.pkgs-unstable.tmuxPlugins) fingers;
        };
    };

  # User-specific overlay for customizations, such as wrapped configuration, etc.
  customized = self: super:
    {
      custom = {
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
      fzf
      git
      iosevka
      metals
      pinentry
      starship
      tmux
      vim
      zshrc

      # Vernilla packages
      pkgs.bash
      pkgs.cacert
      pkgs.coreutils
      pkgs.fasd
      pkgs.fd
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

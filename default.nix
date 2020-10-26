with { pkgs = import ./nix {}; };
let
  # The list of packages to be installed
  packages = with pkgs;
    [
      # Customized packages
      bash-language-server
      dircolors-solarized
      emacs
      fzf
      iosevka
      pinentry
      vmd
      zshrc

      # Vernilla packages
      pkgs.bash
      pkgs.cacert
      pkgs.coreutils
      pkgs.emacs-all-the-icons-fonts
      pkgs.fasd
      pkgs.fd
      pkgs.gawk
      pkgs.git
      pkgs.gitAndTools.hub
      pkgs.gnupg
      pkgs.jq
      pkgs.less
      pkgs.libvterm-neovim
      pkgs.metals
      pkgs.niv.niv
      pkgs.nix
      pkgs.nix-zsh-completions
      pkgs.nodejs-12_x
      pkgs.openjdk
      pkgs.ripgrep
      pkgs.starship
      pkgs.stow
      pkgs.tree
      pkgs.zsh-completions
      pkgs.zsh-syntax-highlighting
    ];

  # A custom '.zshrc' (see './zshrc/default.nix')
  zshrc = pkgs.callPackage ./zsh/zshrc.nix {};

  # Use pinned version of 'dircolors-solarized'
  dircolors-solarized = pkgs.callPackage ./zsh/dircolors-solarized.nix {
    src = pkgs.sources.dircolors-solarized;
  };

  # Node2nix generated expression for 'vmd'
  vmd = pkgs.callPackage ./npm/vmd {
    inherit pkgs;
  };

  # Node2nix generated expression for 'bash-language-server'
  bash-language-server = pkgs.callPackage ./npm/bash-language-server {
    inherit pkgs;
  };

  # The right 'pinentry' for macos
  pinentry = if (pkgs.stdenv.isDarwin) then pkgs.pinentry_mac else pkgs.pinentry;

  # A custom 'fzf' (see './fzf/default.nix')
  fzf = pkgs.callPackage ./fzf { inherit (pkgs) fzf; };

  # A custom font build
  iosevka = import ./iosevka { inherit pkgs; };

  # A custom Emacs with packages
  emacs = import ./emacs { inherit pkgs; };

in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    {
      buildInputs = packages;
      shellHook = ''$(zshrc)'';
    }
  else packages

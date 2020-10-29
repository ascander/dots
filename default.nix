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
      iosevka-nerd
      pinentry
      starship
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
      pkgs.stow
      pkgs.tree
      pkgs.zsh-completions
      pkgs.zsh-syntax-highlighting
    ];

  # Some packages come from the unstable branch
  pkgs-unstable = import pkgs.sources.nixpkgs-unstable {};

  # Node2nix generated expression for 'bash-language-server'
  bash-language-server = pkgs.callPackage ./npm/bash-language-server {
    inherit pkgs;
  };

  # Use pinned version of 'dircolors-solarized'
  dircolors-solarized = pkgs.callPackage ./zsh/dircolors-solarized.nix {
    src = pkgs.sources.dircolors-solarized;
  };

  # A custom Emacs with packages
  emacs = import ./emacs { inherit pkgs; };

  # A custom 'fzf' (see './fzf/default.nix')
  fzf = pkgs.callPackage ./fzf { inherit (pkgs) fzf; };

  # A custom font build
  iosevka = import ./iosevka { inherit pkgs; };

  # Required for starship prompt
  iosevka-nerd = pkgs.nerdfonts.override { fonts = ["Iosevka"]; };

  # The right 'pinentry' for macos
  pinentry = if (pkgs.stdenv.isDarwin) then pkgs.pinentry_mac else pkgs.pinentry;

  # Use the unstable branch of nixpkgs to get version 0.45.x
  starship = pkgs-unstable.starship;

  # Node2nix generated expression for 'vmd'
  vmd = pkgs.callPackage ./npm/vmd {
    inherit pkgs;
  };

  # A custom '.zshrc' (see './zshrc/default.nix')
  zshrc = pkgs.callPackage ./zsh/zshrc.nix {};
in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    {
      buildInputs = packages;
      shellHook = ''$(zshrc)'';
    }
  else packages

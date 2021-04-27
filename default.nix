let
  pkgs = import ./nix {};

  # The list of packages to be installed
  packages = with pkgs;
    [
      # Customized packages
      fzf
      git
      iosevka
      pinentry
      starship
      vim
      zshrc

      # Vernilla packages
      pkgs.bash
      pkgs.cacert
      pkgs.coreutils
      pkgs.fasd
      pkgs.fd
      pkgs.gawk
      pkgs.gitAndTools.gh
      pkgs.gnupg
      pkgs.httpie
      pkgs.iosevka-bin
      pkgs.jq
      pkgs.less
      pkgs.metals
      pkgs.niv.niv
      pkgs.nix
      pkgs.nix-zsh-completions
      pkgs.nodejs-12_x
      pkgs.openjdk
      pkgs.ripgrep
      pkgs.sourceHighlight
      pkgs.stow
      pkgs.tree
      pkgs.zsh-completions
      pkgs.zsh-syntax-highlighting
    ];

  # Some packages come from the unstable branch
  pkgs-unstable = import pkgs.sources.nixpkgs-unstable {};

  # A custom 'fzf' (see './fzf/default.nix')
  fzf = pkgs.callPackage ./fzf { inherit (pkgs) fzf; };

  # A version of 'git' with config and global ignore included
  git = pkgs.callPackage ./git { inherit (pkgs) git; };

  iosevka = pkgs-unstable.iosevka-bin.override {
    variant = "ss08";
  };

  # The right 'pinentry' for macos
  pinentry = if (pkgs.stdenv.isDarwin) then pkgs.pinentry_mac else pkgs.pinentry;

  # Use the unstable branch of nixpkgs to get v0.45.2
  starship = pkgs-unstable.starship;

  # Diary of a Vimpy Kid™
  vim = pkgs.callPackage ./vim {};

  # A custom '.zshrc' (see './zshrc/default.nix')
  zshrc = pkgs.callPackage ./zshrc {};
in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    {
      buildInputs = packages;
      shellHook = ''$(zshrc)'';
    }
  else packages

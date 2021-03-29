with { pkgs = import ./nix {}; };
let
  # The list of packages to be installed
  packages = with pkgs;
    [
      # Customized packages
      fzf
      iosevka
      pinentry
      starship
      zshrc

      # Vernilla packages
      pkgs.bash
      pkgs.cacert
      pkgs.coreutils
      pkgs.fasd
      pkgs.fd
      pkgs.gawk
      pkgs.git
      pkgs.gitAndTools.gh
      pkgs.gnupg
      pkgs.httpie
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

  # A custom font build
  iosevka = import ./iosevka { inherit pkgs; };

  # The right 'pinentry' for macos
  pinentry = if (pkgs.stdenv.isDarwin) then pkgs.pinentry_mac else pkgs.pinentry;

  # Use the unstable branch of nixpkgs to get v0.45.2
  starship = pkgs-unstable.starship;

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

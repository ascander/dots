{
  description = "Ascander's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Nix darwin
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim nightly build
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    neovim-nightly-overlay,
    ...
  } @ inputs: let
    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs.lib) attrValues optionalAttrs singleton;

      currentSystem = "x86_64-darwin";

    # Configuration for 'nixpkgs'
    nixpkgsConfig = {
      config = {allowUnfree = true;};
      overlays = singleton neovim-nightly-overlay.overlay;
    };
  in {
    overlays = {
      # # Adds access to (unstable) x86 packages through 'pkgs.x86' if running Apple Silicon
      # apple-silicon = _: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
      #   x86 = import inputs.nixpkgs-unstable {
      #     system = "x86_64-darwin";
      #     inherit (nixpkgsConfig) config;
      #   };
      # };

      # # Substitute x86 versions of packages that don't build on Apple Silicon yet
      # sub-x86 = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
      #   inherit (final.x86);
      # };

      # Adds access to unstable packages through 'pkgs.unstable'
      pkgs-unstable = _: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev.stdenv) system;
          inherit (nixpkgsConfig) config;
        };
      };
    };

    darwinModules = {
      bootstrap = import ./darwin/bootstrap.nix;
      defaults = import ./darwin/defaults.nix;
      configuration = import ./darwin/configuration.nix;
      homebrew = import ./darwin/homebrew.nix;
    };

    darwinConfigurations = {
      adost-ltm = darwinSystem {
        system = "x86_64-darwin";
        modules =
          attrValues self.darwinModules
          ++ [
            inputs.neovim-nightly-overlay.overlay
          ];
      };
    in
    {
      overlays = {
        # # Adds access to (unstable) x86 packages through 'pkgs.x86' if running Apple Silicon
        # apple-silicon = _: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
        #   x86 = import inputs.nixpkgs-unstable {
        #     system = "x86_64-darwin";
        #     inherit (nixpkgsConfig) config;
        #   };
        # };

        # # Substitute x86 versions of packages that don't build on Apple Silicon yet
        # sub-x86 = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
        #   inherit (final.x86);
        # };

        # Adds access to unstable packages through 'pkgs.unstable'
        pkgs-unstable = _: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

        # Adds Neovim plugins not in `nixpkgs`
        nvim-plugins = final: prev:
          let
            nvim-tree = prev.vimUtils.buildVimPlugin rec {
              name = "nvim-tree";
              src = inputs.nvim-tree;
              version = src.lastModifiedDate;
            };
          in
          {
            vimPlugins =
              prev.vimPlugins
              // {
                inherit nvim-tree;
              };
          };
      };

      darwinModules = {
        bootstrap = import ./darwin/bootstrap.nix;
        defaults = import ./darwin/defaults.nix;
        configuration = import ./darwin/configuration.nix;
        homebrew = import ./darwin/homebrew.nix;
      };

      darwinConfigurations = {
        adost-ltm = darwinSystem {
          system = "x86_64-darwin";
          modules =
            attrValues self.darwinModules
            ++ [
              home-manager.darwinModules.home-manager
              {
                nixpkgs = nixpkgsConfig;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.users.adost = import ./home/home.nix;
                users.users.adost.home = "/Users/adost";
              }
            ];
        };
      };

      formatter.${currentSystem} = nixpkgs.legacyPackages.${currentSystem}.alejandra;
    };
}

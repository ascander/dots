{
  description = "Ascander's darwin system";

  inputs = {
    # Nixpkgs
    # https://github.com/NixOS/nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Nix darwin
    # https://github.com/LnL7/nix-darwin
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    # https://github.com/nix-community/home-manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim nightly overlay
    # https://github.com/nix-community/neovim-nightly-overlay
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      neovim-nightly,
      ...
    }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs.lib) attrValues;

      # Configuration for 'nixpkgs'
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
        };
        overlays = attrValues self.overlays ++ [ neovim-nightly.overlays.default ];
      };
    in
    {
      overlays = {
        # # Adds access to x86 packages through 'pkgs.x86' if running Apple Silicon
        # apple-silicon = _: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
        #   x86 = import inputs.nixpkgs {
        #     system = "x86_64-darwin";
        #     inherit (nixpkgsConfig) config;
        #   };
        # };
        #
        # # Substitute x86 versions of packages that don't build on Apple Silicon yet
        # sub-x86 = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
        #   inherit (final.x86);
        # };
      };

      darwinModules = {
        bootstrap = import ./darwin/bootstrap.nix;
        defaults = import ./darwin/defaults.nix;
        configuration = import ./darwin/configuration.nix;
        homebrew = import ./darwin/homebrew.nix;
      };

      darwinConfigurations = {
        adost-ltmvznn = darwinSystem {
          system = "aarch64-darwin";
          modules = attrValues self.darwinModules ++ [
            home-manager.darwinModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "home-manager-backup";

              home-manager.users.adost = import ./home/home.nix;
              users.users.adost.home = "/Users/adost";
            }
          ];
        };
      };
    };
}

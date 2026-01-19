{
  description = "Darwin configuration for Vaibhav Gopal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, ...  }:
  {
    mkNixos = { rootSelf, configurations, ... }: (
      let
        # Get "nix-darwin" configurations from root flake
        darwinConfigs = nixpkgs.lib.filterAttrs (_: conf: conf.nixType == "nix-darwin") configurations;

        # make the nix-darwin configuration factory function
        genHost = name: conf: nix-darwin.lib.darwinSystem (
        let
          # Common nixpkgs configurations (overlays, unfree packages, etc...) (applies to all except `pkgs` / `nixpkgs` itself ; which you configure in the actual submodules using nixos options)
          commonPkgsConfig = {
            inherit (conf) system;
            config.allowUnfree = true;
          };

          # the base `pkgs` argument is special, it is automatically created / configured and passed in (DO NOT modify, outside of sub modules, many other non-user made modules use this configuration option!)
          # Need to set any other nixpkgs channel / input other than the main one (used to create system config) explicitly here (options DO NOT get passed into submodules)
          pkgs-unstable = import nixpkgs-unstable commonPkgsConfig;

          # pass in: flake inputs // current system configuration // extra nixpkgs channels
          specialArgs = inputs // conf // { inherit pkgs-unstable; };
        in {
          inherit (conf) system; # inherit system > tells which specific `pkgs` / `nixpkgs` version to use 
          inherit specialArgs; # inherit specialArgs > pass in specialArgs into every sub module

          modules = [
            #################CORE#################
            # home-manager includes
            home-manager.darwinModules.home-manager

            # core modules
            rootSelf.nixosModules.usrlib
            rootSelf.nixosModules.home
            rootSelf.nixosModules.nix
            ./modules

            #################USER#################
            ./${name} # automatically looks for a folder named after configuration name
          ];
        });
      in 
        nixpkgs.lib.mapAttrs genHost darwinConfigs 
    );
  };
}

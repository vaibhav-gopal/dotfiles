{
  description = "NixOS configuration for Vaibhav Gopal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ...  }:
  {
    mkConfigs = { mkUserLib, configurations }: (let
      usrlib = mkUserLib { inherit (nixpkgs) lib;};
      nixosConfigs = nixpkgs.lib.filterAttrs (_: conf: conf.nixType == "nixos") configurations;
      genHost = name: conf: nixpkgs.lib.nixosSystem (let
        # Common nixpkgs configurations (overlays, unfree packages, etc...) (applies to all except `pkgs` / `nixpkgs` itself)
        commonPkgsConfig = {
          inherit (conf) system;
          config.allowUnfree = true;
        };
        # the base `pkgs` argument is special, it is automatically created / configured and passed in (DO NOT modify, outside of sub modules, many other non-user made modules use this configuration option!)
        # Need to set any other nixpkgs channel / input other than the main one (used to create system config) explicitly here (options DO NOT get passed into submodules)
        pkgs-unstable = import nixpkgs-unstable commonPkgsConfig;
      in {
        # inherit system > tells which specific `pkgs` / `nixpkgs` version to use
        inherit (conf) system; 
        # create set of extra args to pass in to every sub module
        specialArgs = inputs // conf // {
          inherit pkgs-unstable usrlib;
        };
        modules = [
          #################CORE#################
          # home-manager includes
          home-manager.nixosModules.home-manager

          # include core configs
          ./core
          ./features

          #################USER#################
          ./${name} # automatically looks for a folder named after configuration name
        ];
      });
    in 
      nixpkgs.lib.mapAttrs genHost nixosConfigs 
    );
  };
}
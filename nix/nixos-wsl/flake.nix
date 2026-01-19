{  
  description = "NixOS - WSL2 Configuration for Vaibhav Gopal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Uses custom version of nixos specifically for WSL2
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixos-wsl, home-manager, ... }:
  {
    mkNixos = { rootSelf, configurations, ... }: (
      let
        # Get "nixos" configurations from root flake
        nixosConfigs = nixpkgs.lib.filterAttrs (_: conf: conf.nixType == "nixos-wsl") configurations;

        # make the nixos configuration factory function
        genHost = name: conf: nixpkgs.lib.nixosSystem (
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
            # include nixos-wsl modules by default
            nixos-wsl.nixosModules.default

            # home-manager includes
            home-manager.nixosModules.home-manager

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
        nixpkgs.lib.mapAttrs genHost nixosConfigs 
    );

    mkHome = { rootSelf, configurations, ... }: (
      let
        nixosConfigs = nixpkgs.lib.filterAttrs (_: conf: conf.nixType == "nixos-wsl") configurations;
        genHome = name: conf: home-manager.lib.homeManagerConfiguration (
        let
          commonPkgsConfig = {
            inherit (conf) system;
            config.allowUnfree = true;
          };
          pkgs = import nixpkgs commonPkgsConfig;
          pkgs-unstable = import nixpkgs-unstable commonPkgsConfig;
          extraSpecialArgs = inputs // conf // { inherit pkgs pkgs-unstable; };
        in {
          inherit pkgs extraSpecialArgs;

          modules = [
            #################CORE#################
            rootSelf.homeModules.home
            rootSelf.nixosModules.usrlib
          ];
        });
      in
        nixpkgs.lib.mapAttrs genHome nixosConfigs
    );
  };
}

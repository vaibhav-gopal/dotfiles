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
  let
    configurations = {
      vgwsl2 = {
        username = "vaibhav";
        hostname = "vgwsl2";
        system = "x86_64-linux";
        version = "25.11";
        homedirectory = "/home/vaibhav";
        nixType = "nixos-wsl";
      };
    };
  in {
    nixosConfigurations = {
      vgwsl2 = nixpkgs.lib.nixosSystem (let 
        # Common nixpkgs configurations (overlays, unfree packages, etc...) (applies to all except `pkgs` / `nixpkgs` itself)
        commonPkgsConfig = with configurations.vgwsl2; {
          inherit system;
          config.allowUnfree = true;
        };

        # the base `pkgs` argument is special, it is automatically created / configured and passed in (DO NOT modify, outside of sub modules, many other non-user made modules use this configuration option!)
        # Need to set any other nixpkgs channel / input other than the main one (used to create system config) explicitly here (options DO NOT get passed into submodules)
        pkgs-unstable = import nixpkgs-unstable commonPkgsConfig;

        # create set of extra args to pass in to every sub module
        specialArgs = inputs // configurations.vgwsl2 // {
          inherit pkgs-unstable;
        };
      in with configurations.vgwsl2; {
        # inherit system > tells which specific `pkgs` / `nixpkgs` version to use | inherit specialArgs > read above
        inherit system specialArgs;
        modules = [
          #################CORE#################
          # include nixos-wsl modules by default
          nixos-wsl.nixosModules.default

          # home-manager includes
          home-manager.nixosModules.home-manager

          # include core configs
          ./features

          #################USER#################
          ./vgwsl2
        ];
      });
    };
  };
}

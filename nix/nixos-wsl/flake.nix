{  
  description = "NixOS - WSL2 Configuration for Vaibhav Gopal";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # Uses custom version of nixos specifically for WSL2
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-wsl, home-manager, ... }:
  let
    configurations = {
      vgwsl2 = {
        username = "vaibhav";
        hostname = "vgwsl2";
        system = "x86_64-linux";
        version = "25.05";
        homedirectory = "/home/vaibhav";
      };
    };
  in {
    # export configurations as an output
    inherit configurations;

    # main nixos-wsl configurations
    nixosConfigurations = {
      vgwsl2 = nixpkgs.lib.nixosSystem (let 
          specialArgs = inputs // configurations.vgwsl2;
        in with configurations.vgwsl2; {
        inherit system specialArgs;
        modules = [
          #################USER#################
          ./vgwsl2/configuration.nix

          #################CORE#################
          # include core configs
          ./core/configuration.nix
          # include nixos-wsl modules by default
          nixos-wsl.nixosModules.default
          # home-manager includes
          home-manager.nixosModules.home-manager
        ];
      });
    };
  };
}

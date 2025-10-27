{  
  description = "NixOS - WSL2 Configuration for Vaibhav Gopal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixos-wsl, home-manager, ... }:
  let
    configurations = {
      vgwsl2 = {
        username = "vaibhav";
        hostname = "vgwsl2";
        system = "x86_64-linux";
        version = "25.05";
        homedirectory = "/home/vaibhav";
        nixType = "nixos-wsl";
      };
    };
  in {
    # export configurations as an output
    inherit configurations;

    # main nixos-wsl configurations
    nixosConfigurations = {
      vgwsl2 = nixpkgs.lib.nixosSystem (let 
          # nixpkgs is automatically parsed as `pkgs` and passed in, everything else however is still named the same
          # select the proper nixpkgs-unstable subset with system and pass through as `pkgs-unstable`
          specialArgs = inputs // configurations.vgwsl2 // {
            pkgs-unstable = with configurations.vgwsl2; import nixpkgs-unstable {
              inherit system;
            };
          };
        in with configurations.vgwsl2; {
        inherit system specialArgs;
        modules = [
          #################CORE#################
          # include nixos-wsl modules by default
          nixos-wsl.nixosModules.default
          # home-manager includes
          home-manager.nixosModules.home-manager
          # include core configs
          ./core/configuration.nix

          #################USER#################
          ./vgwsl2/configuration.nix
        ];
      });
    };
  };
}

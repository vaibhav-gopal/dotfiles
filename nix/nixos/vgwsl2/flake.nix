{  
  description = "NixOS - WSL2 Configuration for Vaibhav Gopal";

  # Edit this configuration file to define what should be installed on
  # your system. Help is available in the configuration.nix(5) man page, on
  # https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

  # NixOS-WSL specific options are documented on the NixOS-WSL repository:
  # https://github.com/nix-community/NixOS-WSL

  # the nixConfig here only affects the flake itself, not the system configuration!
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
    username = "vaibhav";
    hostname = "vgwsl2";
    system = "x86_64-linux";
    version = "25.05";
    homedirectory = "/home/vaibhav";


    specialArgs = inputs // {
      inherit username hostname version homedirectory;
    };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./modules/configuration.nix

          # include nixos-wsl modules by default
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = version;
            wsl.enable = true;
	          wsl.defaultUser = username;
            networking.hostName = hostname;
            nix.settings.experimental-features = ["nix-command" "flakes"];
          }

          # home-manager includes
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.backupFileExtension = "backup-before-home-manager-nixos";
            home-manager.users.${username} = import ../../../home/home.nix;
          }
        ];
      };
    };
  };
}

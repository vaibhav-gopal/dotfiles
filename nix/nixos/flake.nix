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
  let
    configurations = {
      vgkraken = {
        username = "vaibhav";
        system = "x86_64-linux";
        hostname = "vgkraken";
        version = "25.11"; # remember this is state version not nixpkgs version!
        homedirectory = "/home/vaibhav";
        nixType = "nixos";
      };
      vgnixmini = {
        username = "vaibhav";
        system = "x86_64-linux";
        hostname = "vgnixmini";
        version = "25.11";
        homedirectory = "/home/vaibhav";
        nixType = "nixos";
      };
    };
  in {
    nixosConfigurations = {
      vgkraken = nixpkgs.lib.nixosSystem (let
        # Common nixpkgs configurations (overlays, unfree packages, etc...) (applies to all except `pkgs` / `nixpkgs` itself)
        commonPkgsConfig = with configurations.vgkraken; {
          inherit system;
          config.allowUnfree = true;
        };

        # the base `pkgs` argument is special, it is automatically created / configured and passed in (DO NOT modify, outside of sub modules, many other non-user made modules use this configuration option!)
        # Need to set any other nixpkgs channel / input other than the main one (used to create system config) explicitly here (options DO NOT get passed into submodules)
        pkgs-unstable = import nixpkgs-unstable commonPkgsConfig;

        # create set of extra args to pass in to every sub module
        specialArgs = inputs // configurations.vgkraken // {
          inherit pkgs-unstable;
        };
      in with configurations.vgkraken; {
        # inherit system > tells which specific `pkgs` / `nixpkgs` version to use | inherit specialArgs > read above
        inherit system specialArgs;
        modules = [
          #################CORE#################
          # home-manager includes
          home-manager.nixosModules.home-manager

          # include feature configs
          ./features

          #################USER#################
          ./vgkraken
        ];
      });

      vgnixmini = nixpkgs.lib.nixosSystem (let
        commonPkgsConfig = with configurations.vgnixmini; {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-unstable = import nixpkgs-unstable commonPkgsConfig;
        specialArgs = inputs // configurations.vgnixmini // {
          inherit pkgs-unstable;
        };
      in with configurations.vgnixmini; {
        inherit system specialArgs;
        modules = [
          #################CORE#################
          # home-manager includes
          home-manager.nixosModules.home-manager

          # include feature configs
          ./features

          #################USER#################
          ./vgnixmini
        ];
      });
    };
  };
}
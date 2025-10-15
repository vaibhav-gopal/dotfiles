{
  description = "Darwin configuration for Vaibhav Gopal";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, ...  }:
  let 
    configurations = {
      vgmacbook = {
        username = "vaibhav";
        system = "aarch64-darwin";
        hostname = "vgmacbook";
        version = "25.05"; # remember this is state version not nixpkgs version!
        homedirectory = "/Users/vaibhav";
      };
    };
  in {
    # export configurations as an output
    inherit configurations;

    # main nix-darwin configurations
    darwinConfigurations = {
      vgmacbook = nix-darwin.lib.darwinSystem (let 
          specialArgs = inputs // configurations.vgmacbook;
        in with configurations.vgmacbook; {
        inherit system specialArgs;
        modules = [
          #################USER#################
          ./vgmacbook/configuration.nix

          #################CORE#################
          # include core configs
          ./core/configuration.nix
          # home-manager includes
          home-manager.darwinModules.home-manager
        ];
      });
    };
  };
}

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
  let 
    configurations = {
      vgmacbook = {
        username = "vaibhav";
        system = "aarch64-darwin";
        hostname = "vgmacbook";
        version = "25.11"; # remember this is state version not nixpkgs version!
        homedirectory = "/Users/vaibhav";
        nixType = "nix-darwin";
      };
    };
  in {
    darwinConfigurations = {
      vgmacbook = nix-darwin.lib.darwinSystem (let 
        # Common nixpkgs configurations (overlays, unfree packages, etc...) (applies to all except `pkgs` / `nixpkgs` itself)
        commonPkgsConfig = with configurations.vgmacbook; {
          inherit system;
          config.allowUnfree = true;
        };

        # the base `pkgs` argument is special, it is automatically created / configured and passed in (DO NOT modify, outside of sub modules, many other non-user made modules use this configuration option!)
        # Need to set any other nixpkgs channel / input other than the main one (used to create system config) explicitly here (options DO NOT get passed into submodules)
        pkgs-unstable = import nixpkgs-unstable commonPkgsConfig;

        # create set of extra args to pass in to every sub module
        specialArgs = inputs // configurations.vgmacbook // {
          inherit pkgs-unstable;
        };
      in with configurations.vgmacbook; {
        # inherit system > tells which specific `pkgs` / `nixpkgs` version to use | inherit specialArgs > read above
        inherit system specialArgs;
        modules = [
          #################CORE#################
          # home-manager includes
          home-manager.darwinModules.home-manager

          # include feature configs
          ./features

          #################USER#################
          ./vgmacbook
        ];
      });
    };
  };
}

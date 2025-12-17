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
    # export configurations as an output
    inherit configurations;

    # main nix-darwin configurations
    darwinConfigurations = {
      vgmacbook = nix-darwin.lib.darwinSystem (let 
          # nixpkgs is automatically parsed as `pkgs` and passed in, everything else however is still named the same
          # select the proper nixpkgs-unstable subset with system and pass through as `pkgs-unstable`
          specialArgs = inputs // configurations.vgmacbook // {
            pkgs-unstable = with configurations.vgmacbook; import nixpkgs-unstable {
              inherit system;
            };
          };
        in with configurations.vgmacbook; {
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

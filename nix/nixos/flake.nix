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
        version = "25.11"; # remember this is state version not nixpkgs version!
        homedirectory = "/home/vaibhav";
        nixType = "nixos";
      };
    };
  in {
    # export configurations as an output
    inherit configurations;

    # main nixos configurations
    nixosConfigurations = {
      vgkraken = nixpkgs.lib.nixosSystem (let
        # nixpkgs is automatically parsed as `pkgs` and passed in, everything else however is still named the same
        # select the proper nixpkgs-unstable subset with system and pass through as `pkgs-unstable`
        specialArgs = inputs // configurations.vgkraken // {
          pkgs-unstable = with configurations.vgkraken; import nixpkgs-unstable {
            inherit system;
          };
        };
      in with configurations.vgkraken; {
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
        # nixpkgs is automatically parsed as `pkgs` and passed in, everything else however is still named the same
        # select the proper nixpkgs-unstable subset with system and pass through as `pkgs-unstable`
        specialArgs = inputs // configurations.vgnixmini // {
          pkgs-unstable = with configurations.vgnixmini; import nixpkgs-unstable {
            inherit system;
          };
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

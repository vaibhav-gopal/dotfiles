{
  # A brief description of the flake.
  description = "Bare minimum Home Manager configuration for Vaibhav Gopal";

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    # Input for the Nix Packages collection, pinned to the 25.05 release.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Input for Home Manager, pinned to the matching nixpkgs release.
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      username = "vaibhav";
      system = "__SYSTEM__";
      hostname = "__HOSTNAME__";
      useremail = "vabsgop@gmail.com";
      version = "25.05";
      homedirectory = "/home/vaibhav";

      specialArgs =
        inputs
        // {
          inherit username useremail hostname version homedirectory;
        };

    in {
      # Expose the generated homeConfigurations.
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."${system}";
        modules = [../../home/home.nix];
        extraSpecialArgs = specialArgs;
      };
    };
}


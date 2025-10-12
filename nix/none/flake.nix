{
  # A brief description of the flake.
  description = "Bare minimum Home Manager configuration for Vaibhav Gopal";

  inputs = {
    # Input for the Nix Packages collection, pinned to the 25.05 release.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Input for Home Manager, pinned to the matching nixpkgs release.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      username = "vaibhav";
      system = "x86_64";
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


{
  description = "Darwin configuration for Vaibhav Gopal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, ...  }:
    let 
      username = "vaibhav";
      system = "aarch64-darwin";
      hostname = "vgmacbook";
      useremail = "vabsgop@gmail.com";
      version = "25.05";
      homedirectory = "/Users/vaibhav";

      specialArgs =
        inputs
        // {
          inherit username useremail hostname version homedirectory;
        };
    in {
      darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules = [
          # general : .nix files to be evaluated
          ./modules/system.nix
          ./modules/core.nix
          ./modules/env.nix

          # home manager : import and configure
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = import ../../home/home.nix;
          }
        ];
      }; 
    };
}

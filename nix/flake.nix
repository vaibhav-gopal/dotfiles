{
  description = "Master Flake Composition";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # Local sub-flakes
    nixos-src.url = "path:./nixos";
    darwin-src.url = "path:./nix-darwin";
    wsl-src.url = "path:./nixos-wsl";
  };

  outputs = { self, nixpkgs, nixos-src, darwin-src, wsl-src, ... }: 
    let
      # attribute set of all configurations
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
        vgwsl2 = {
          username = "vaibhav";
          hostname = "vgwsl2";
          system = "x86_64-linux";
          version = "25.11";
          homedirectory = "/home/vaibhav";
          nixType = "nixos-wsl";
        };
        vgmacbook = {
          username = "vaibhav";
          system = "aarch64-darwin";
          hostname = "vgmacbook";
          version = "25.11"; # remember this is state version not nixpkgs version!
          homedirectory = "/Users/vaibhav";
          nixType = "nix-darwin";
        };
      };

      baseArgs = { 
        inherit configurations;
        rootSelf = self;
      };
    in {
      nixosConfigurations = (nixos-src.outputs.mkNixos baseArgs) // (wsl-src.outputs.mkNixos baseArgs);
      darwinConfigurations = (darwin-src.outputs.mkNixos baseArgs);
      homeConfigurations = (nixos-src.outputs.mkHome baseArgs) // (wsl-src.outputs.mkHome baseArgs) // (darwin-src.outputs.mkHome baseArgs);

      # reusable modules ; use within sub-flakes by accessing rootSelf.nixosModules
      nixosModules = {
        usrlib = import ./modules/usrlib.nix;
        home = import ./modules/home.nix;
        nix = import ./modules/nix.nix;
      };

      homeModules = {
        home = import ../home/default.nix;
      };
    };
}
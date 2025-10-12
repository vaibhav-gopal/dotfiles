{
  # A brief description of the flake.
  description = "Home Manager configuration for Vaibhav Gopal";

  inputs = {
    # Input for the Nix Packages collection, pinned to the 25.05 release.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Input for Home Manager, pinned to the matching nixpkgs release.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Important paths to define
      hmPaths = {
        dotfilesDir = ./.;
        homeDir = ./home;
        homeCommonDir = ./home/common;
        homeCommonConfigsDir = ./home/common/configs;
        homeFeaturesDir = ./home/features;
        modesNix = ./modes.nix;
        bootstrapScript = ./bootstrap.sh;
      };
      
      # Import a list of configurations (e.g. different users or modes). Ensure it is a list
      modeConfigs = import hmPaths.modesNix { inherit hmPaths; };

      # Extract a unique list (via attrset conversion) of all systems mentioned in the configs. (List -> Set (unique) -> List)
      systems = builtins.attrNames (builtins.listToAttrs (
        map (cfg: {
          name = cfg.system;
          value = true;
        }) modeConfigs
      ));

      # Create a `pkgs` set for each system using the appropriate nixpkgs.
      pkgsFor = nixpkgs.lib.genAttrs systems (system:
        import nixpkgs {
          inherit system;
        }
      );

      # Generate Home Manager configurations for each mode config.
      # First give each configuration a pkgs with the specific system. Then give it the configuration specific flake via modules.
      homeConfigurations = builtins.listToAttrs (map (cfg: {
        name = cfg.modeName;
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.${cfg.system};
          modules = [ cfg.modePath ];
          extraSpecialArgs = {
            inherit hmPaths;
            modeConfig = cfg;
          };
        };
      }) modeConfigs);
    in {
      # Expose the generated homeConfigurations.
      inherit homeConfigurations;
    };
}


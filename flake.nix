{
  # A brief description of the flake.
  description = "Home Manager configuration for Vaibhav Gopal";

  inputs = {
    # Input for the Nix Packages collection, pinned to the 24.11 release.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # Input for Home Manager, pinned to the matching 24.11 release.
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      # Ensure Home Manager uses the same nixpkgs version.
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
        homeFeaturesDir = ./home/features;
        modesNix = ./modes.nix;
        bootstrapScript = ./bootstrap.sh;
      };
      
      # Import a list of configurations (e.g. different users or modes).
      modeConfigs = import hmPaths.modesNix { inherit hmPaths; };

      # Extract a unique list of all systems mentioned in the configs.
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

      # Provide a devShell for `nix develop`, usable with: HM_MODE_NAME=... nix develop
      devShells = nixpkgs.lib.genAttrs systems (system:
        let
          pkgs = pkgsFor.${system};
        in {
          default = pkgs.mkShell {
            name = "home-manager-dev-shell";

            buildInputs = [
              pkgs.nix       # ensures nix CLI is available
              pkgs.jq        # for parsing modes.nix output
              pkgs.gnused    # GNU sed (more consistent)
              pkgs.coreutils # dirname, readlink, etc.
              pkgs.bash      # bash is used in the script
            ];

            shellHook = ''
              ${hmPaths.bootstrapScript} "$HM_MODE_NAME" || exit 1
              exit 0
            '';  
          };
        }
      );
    };
}


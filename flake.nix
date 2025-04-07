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
      # Import a list of configurations (e.g. different users or modes).
      modeConfigs = import ./modes.nix;

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
        # The name of the configuration (e.g. "vaibhav@laptop").
        name = cfg.modeName;

        value = home-manager.lib.homeManagerConfiguration {
          # Pick the correct pkgs set based on system architecture.
          pkgs = pkgsFor.${cfg.system};

          # Home Manager module to use (typically a path to a .nix file).
          modules = [ cfg.modePath ];

          # Pass the full config (like username, system, mode, etc.) to the module.
          extraSpecialArgs = {
            modeConfig = cfg; 
          }; 
        };
      }) modeConfigs);
    in {
      # Expose the generated homeConfigurations.
      inherit homeConfigurations;
    };
}

{ config, pkgs, lib, modeConfig, hmPaths, ... }:

# This Home Manager configuration imports:
# - A common base configuration (shared across all modes)
# - A set of feature modules defined per-mode in `modeConfig.features`
# Each feature is expected to live in: ${hmPaths.homeFeaturesDir}/<feature>/default.nix

let
  # Dynamically map the feature names to their module paths
  featureModules = map
    (name: hmPaths.homeFeaturesDir + "/${name}")
    modeConfig.features;
in
{
  # Import shared base configuration and feature modules
  imports = featureModules ++ [
    hmPaths.homeCommonDir
  ];
}

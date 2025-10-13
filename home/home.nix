args@{ pkgs, config, lib, ... }:
let
  # Important paths to define and load immediately!
  hmPaths = {
    homeCommonDir = ./common;
    homeCommonConfigsDir = ./common/configs;
    homeFeaturesDir = ./features;
    configsNix = ./configs.nix;
  };
  
  # Import a list of configurations based on username and hostname. Ensure it is a list
  configs = import hmPaths.configsNix (args // {inherit hmPaths;});
  
  # Only include features that actually exist
  features = (configs.features or []);
  featureDirs = builtins.filter builtins.pathExists
    (map (name: hmPaths.homeFeaturesDir + "/${name}") features);

  # Import each feature module WITH the extra args
  featureModules = map
    (dir: import dir (args // { inherit hmPaths configs; }))
    featureDirs;
in {
  # Expose the per-system nix files and common nix files
  imports = featureModules ++ [
    (import hmPaths.homeCommonDir (args // {inherit hmPaths configs;}))
    (import configs.systemPath (args // {inherit hmPaths configs;}))
  ];
}
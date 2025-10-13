args@{ ... }:
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

  # Dynamically map the feature names to their module paths
  featureModules = map
    (name: hmPaths.homeFeaturesDir + "/${name}")
    configs.features;
in {
  # Expose the per-system nix files and common nix files
  imports = featureModules ++ [
    (import hmPaths.homeCommonDir (args // {inherit hmPaths configs;}))
    (import configs.systemPath (args // {inherit hmPaths configs;}))
  ];
}
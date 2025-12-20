{ config, lib, nixType, ... }:

let
  # List of enabled features (used both here to enable features and used by features to search the directory for configs)
  # Therefore every feature must:
  # - Have the same name as the directory enclosing it
  # - Have an option called <feature>.enable
  feature-list = [
    "keyboard"
  ];
in {
  options.${nixType}.features.feature-list = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = feature-list;
    description = "A list of all features that are known ; can be overriden per user";
  };
  
  imports = [
    # Features
    ./keyboard
  ];

  # Auto: for each name in feature-list, set features.<name>.enable = mkDefault true
  config = {
    ${nixType}.features = lib.mkMerge (map
      (feature: lib.setAttrByPath [feature "enable"] (lib.mkDefault true))
      feature-list);
    home.file."${config.extPaths.dotfilesEnvDir}/darwin_feature_list.temp".text =
      lib.strings.concatStringsSep "\n" feature-list;
  };
}

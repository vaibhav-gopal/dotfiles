{ config, lib, ... }:

let
  # List of enabled features (used both here to enable features and used by features to search the directory for configs)
  # Therefore every feature must:
  # - Have the same name as the directory enclosing it
  # - Have an option called <feature>.enable
  feature-list = ["bun" "cpp" "git" "glow" "rustup" "shell" "ssh" "term" "uv" "vim"];
in {
  options.features.feature-list = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = feature-list;
    description = "A list of all features that are known ; can be overriden per user";
  };

  imports = [
    ./base.nix
    ./bun
    ./cpp
    ./git
    ./glow
    ./rustup
    ./shell
    ./ssh
    ./term
    ./uv
    ./vim
  ];

  # Auto: for each name in feature-list, set features.<name>.enable = mkDefault true
  config = lib.mkMerge (map 
    (feature: lib.setAttrByPath ["features" feature "enable"] (lib.mkDefault true))
    feature-list);
}
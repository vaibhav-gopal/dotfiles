{ config, lib, pkgs, pkgs-unstable, ... }:

let
  cfg = config.features.default-list;
in {
  options.features.known-list = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = ["bun" "cpp" "glow" "rustup" "uv"];
    description = "A list of all features that are known ; can be overriden per user";
  };
  options.features.default-list = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = ["bun" "cpp" "glow" "rustup" "uv"];
    description = "A list of all features that are enabled by default ; can be overriden per user";
  };

  imports = [
    ./bun
    ./cpp
    ./glow
    ./rustup
    ./uv
  ];

  # Auto: for each name in known-list, set features.<name>.enable = mkDefault true
  config = lib.mkMerge (map 
    (feature: lib.setAttrByPath ["feature" feature "enable"] (lib.mkDefault true))
    cfg);
}
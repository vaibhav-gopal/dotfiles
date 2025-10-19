{ config, lib, ... }:

let
  feature-list = ["git" "shell" "term" "ssh" "vim" "bun" "cpp" "glow" "rustup" "uv"];
in {
  options.features.known-list = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = feature-list;
    description = "A list of all features that are known ; can be overriden per user";
  };
  options.features.default-list = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = feature-list;
    description = "A list of all features that are enabled by default ; can be overriden per user";
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

  # Auto: for each name in known-list, set features.<name>.enable = mkDefault true
  config = lib.mkMerge (map 
    (feature: lib.setAttrByPath ["feature" feature "enable"] (lib.mkDefault true))
    config.features.default-list);
}
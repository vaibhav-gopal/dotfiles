{ config, lib, ... }:

let
  cfg = config.darwin.yabai;
in {
  options.darwin.yabai = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable yabai window manager for macos";
    };
    config = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Yabai config, (key-value pairs)";
      default = {};
    };
  };

  config.services.yabai = lib.mkIf cfg.enable {
    enable = true;
    config = cfg.config;
  };
}
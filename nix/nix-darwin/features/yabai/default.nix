{ config, lib, nixType, ... }:

let
  cfg = config.${nixType}.yabai;
in {
  options.${nixType}.yabai = {
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
    # For SIP explanation and features enabled by disabling it ; Please see https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
    # NOTE: Also need to change some system configuration settings for yabai to work properly! See https://github.com/koekeishiya/yabai/wiki#installation-requirements
    # **mostly don't need the SIP enabled features! (mainly `space` manipulation (aka. the multiple desktops feature called `spaces`), PIP (dynamic picture in picture support), window layers (always on top, moving between layers, etc...))
    # for alternatives see "aerospace" (actually pretty good, works without SIP ; also a nix-darwin provided service)
    enableFullFeatures = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable full yabai features ; BIG WARNING! Requires you to partially disable SIP (system integrity protection), enabling yabai to inject scripts into the native window manager";
    };
  };

  config.services.yabai = lib.mkIf cfg.enable {
    enable = true;
    config = cfg.config;
    enableScriptingAddition = cfg.enableFullFeatures;
  };
}

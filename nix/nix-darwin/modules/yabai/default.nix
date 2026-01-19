{ config, lib, usrlib, ... }:

let
  cfg = config.modules.yabai;
in {
  options.modules.yabai = {
    enable = usrlib.mkEnableOptionFalse "enable yabai window manager for macos";
    # For SIP explanation and features enabled by disabling it ; Please see https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
    # NOTE: Also need to change some system configuration settings for yabai to work properly! See https://github.com/koekeishiya/yabai/wiki#installation-requirements
    # **mostly don't need the SIP enabled features! (mainly `space` manipulation (aka. the multiple desktops feature called `spaces`), PIP (dynamic picture in picture support), window layers (always on top, moving between layers, etc...))
    # for alternatives see "aerospace" (actually pretty good, works without SIP ; also a nix-darwin provided service)
    enable_full_features = usrlib.mkEnableOptionFalse "enable full yabai features ; BIG WARNING! Requires you to partially disable SIP (system integrity protection), enabling yabai to inject scripts into the native window manager";
    config = usrlib.mkAttrsOption "Yabai config, (key-value pairs)" {};
  };

  config.services.yabai = lib.mkIf cfg.enable {
    enable = true;
    config = cfg.config;
    enableScriptingAddition = cfg.enable_full_features;
  };
}

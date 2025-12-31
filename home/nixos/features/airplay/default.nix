{ config, lib, usrlib, ... }:
let
  cfg = config.system.features.airplay;
in {
  options.system.features.airplay = {
    enable = usrlib.mkEnableOptionTrue "Enable uxplay application via uxplay and avahi (enabled in seperate nixos config)";
  };

  config = lib.mkIf cfg.enable {
    # link to .local/share/applications/*
    # adds an application entry to the desktop environment's application menu
    xdg.dataFile."applications/uxplay.desktop".source = ./uxplay.d/uxplay.desktop;
    xdg.dataFile."applications/uxplay.svg".source = ./uxplay.d/uxplay.png;
  };
}

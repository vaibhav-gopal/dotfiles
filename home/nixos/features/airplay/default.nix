{ config, lib, usrlib, ... }:
let
  cfg = config.system.features.airplay;
in {
  options.system.features.airplay = {
    enable = usrlib.mkEnableOptionTrue "Enable airplay config via uxplay and avahi (enabled in seperate nixos config)";
  };

  config = lib.mkIf cfg.enable {
    # link to .local/share/applications/*
    xdg.dataFile."applications/uxplay.desktop".source = ./uxplay.d/uxplay.desktop;
    xdg.dataFile."applications/uxplay.svg".source = ./uxplay.d/uxplay.svg;
  };
}

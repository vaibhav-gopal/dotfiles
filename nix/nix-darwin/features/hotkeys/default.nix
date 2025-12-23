{ config, lib, usrlib, ... }:

let
  cfg = config.features.hotkeys;
in {
  options.features.hotkeys = {
    enable = usrlib.mkEnableOptionTrue "enable skhd hotkey daemon";
    config = usrlib.mkLinesOption "The skhd config (hotkey shortcuts)" '''';
  };

  config.services.skhd = lib.mkIf cfg.enable {
    enable = true;
    skhdConfig = cfg.config;
  };
}

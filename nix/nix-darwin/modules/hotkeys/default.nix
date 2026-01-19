{ config, lib, usrlib, ... }:

let
  cfg = config.modules.hotkeys;
in {
  options.modules.hotkeys = {
    enable = usrlib.mkEnableOptionTrue "enable skhd hotkey daemon";
    config = usrlib.mkLinesOption "The skhd config (hotkey shortcuts)" '''';
  };

  config.services.skhd = lib.mkIf cfg.enable {
    enable = true;
    skhdConfig = cfg.config;
  };
}

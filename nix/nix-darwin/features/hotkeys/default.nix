{ config, lib, ... }:

let
  cfg = config.features.hotkeys;
in {
  options.features.hotkeys = {
    enable = lib.mkEnableOption "enable skhd hotkey daemon" // { default = true; };
    config = lib.mkOption {
      type = lib.types.str;
      description = "The skhd config (hotkey shortcuts)";
      default = ''
      '';
    };
  };

  config.services.skhd = lib.mkIf cfg.enable {
    enable = true;
    skhdConfig = cfg.config;
  };
}

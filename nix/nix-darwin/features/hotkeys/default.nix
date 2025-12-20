{ config, lib, ... }:

let
  cfg = config.features.hotkeys;
in {
  options.features.hotkeys = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable skhd hotkey daemon";
    };
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

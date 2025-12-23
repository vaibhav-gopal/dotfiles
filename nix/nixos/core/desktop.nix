{ config, lib, ... }:
let
  cfglogin = config.core.login;
  cfgdesktop = config.core.desktop;
in {
  options.core.login = {
    enable = lib.mkEnableOption "enable login session / greeter config (display manager, etc...)" // { default = true; };
    select = lib.mkOption {
      type = lib.types.enum [ "sddm" ];
      default = "sddm";
      description = "Chosen display manager";
    };
  };
  options.core.desktop = {
    enable = lib.mkEnableOption "enable x11 windowing system and a desktop environment" // { default = true; };
    select = lib.mkOption {
      type = lib.types.enum [ "plasma" "hyprland" ];
      default = "plasma";
      description = "Chosen desktop environment / compositor";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfglogin.enable && cfglogin.select == "sddm") {
      # Enable the simple desktop display manager (SDDM)
      services.displayManager.sddm.enable = true;
    })
    (lib.mkIf (cfgdesktop.enable && cfgdesktop.select == "plasma") {
      # Enable the KDE Plasma Desktop Environment.
      services.desktopManager.plasma6.enable = true;
    })
    (lib.mkIf (cfgdesktop.enable && cfgdesktop.select == "hyprland") {
    })
    (lib.mkIf cfgdesktop.enable {
      # Enable the X11 windowing system.
      services.xserver.enable = true;
      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };
    })
  ];
}
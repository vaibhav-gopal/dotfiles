{ config, lib, ... }:
let
  cfgx11 = config.features.x11;
  cfgdm = config.features.displaymanager;
  cfgplasma = config.features.plasma;
in {
  options.features.x11 = {
    enable = lib.mkEnableOption "enable x11 windowing system" // { default = true; };
  };
  options.features.displaymanager = {
    enable = lib.mkEnableOption "enable a display manager (login / display manager)" // { default = true; };
    select = lib.mkOption {
      type = lib.types.enum [ "sddm" ];
      default = "sddm";
      description = "Chosen display manager";
    };
  };
  options.features.plasma = {
    enable = lib.mkEnableOption "enable KDE plasma desktop environment" // { default = true; };
  };

  config = lib.mkMerge [
    (lib.mkIf cfgx11.enable {
      # Enable the X11 windowing system.
      services.xserver.enable = true;
      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };
    })
    (lib.mkIf (cfgdm.enable && cfgdm.select == "sddm") {
      # Enable the simple desktop display manager (SDDM)
      services.displayManager.sddm.enable = true;
    })
    (lib.mkIf cfgplasma.enable {
      # Enable the KDE Plasma Desktop Environment.
      services.desktopManager.plasma6.enable = true;
    })
  ];
}
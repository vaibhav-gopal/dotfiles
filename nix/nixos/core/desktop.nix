{ config, lib, usrlib, ... }:
let
  cfglogin = config.core.login;
  cfgdesktop = config.core.desktop;
in {
  options.core.login = {
    enable = usrlib.mkEnableOptionTrue "enable login session / greeter config (display manager, etc...)";
    select = usrlib.mkEnumOption "Chosen display manager" "sddm" [ "sddm" ];
  };
  options.core.desktop = {
    enable = usrlib.mkEnableOptionTrue "enable x11 windowing system and a desktop environment";
    select = usrlib.mkEnumOption "Chosen desktop environment / compositor" "plasma" [ "plasma" "hyprland" ];
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
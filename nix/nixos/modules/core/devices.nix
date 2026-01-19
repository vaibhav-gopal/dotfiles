{ config, lib, usrlib, pkgs, ... }:
let
  cfgmouse = config.core.mouse;
  cfgqmk = config.core.qmk;
in {
  options.core.mouse = {
    enable = usrlib.mkEnableOptionTrue "enable a mouse remapper + dpi management tool (via solaar)";
    package = usrlib.mkPackageOption "The solaar package to use" pkgs.solaar;
    window = usrlib.mkEnumOption "Start with window showing / hidden / only (no tray icon)" "hide" [ "show" "hide" "only" ];
    batteryIcons = usrlib.mkEnumOption "Prefer regular battery / symbolic battery / solaar icons" "regular" [ "regular" "symbolic" "solaar" ];
    extraArgs = usrlib.mkStringOption "Extra arguments to pass to Solaar" "";
  };
  options.core.qmk = {
    enable = usrlib.mkEnableOptionTrue "enable QMK firmware flasher / tool";
    package = usrlib.mkPackageOption "The qmk package to use" pkgs.qmk;
    via = {
      enable = usrlib.mkEnableOptionTrue "enable VIA, a firmware loader without need for flashing";
      package = usrlib.mkPackageOption "The via package to use" pkgs.via;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfgmouse.enable {
      environment.systemPackages = [ cfgmouse.package ];
      hardware.logitech.wireless.enable = true;
      hardware.logitech.wireless.enableGraphical = false;

      systemd.user.services.solaar = {
        description = "Solaar, the open source driver for Logitech devices";
        wantedBy = [ "graphical-session.target" ];
        after = [ "dbus.service" ];
        serviceConfig = {
          Type = "simple";
          ExecStart =
            "${cfgmouse.package}/bin/solaar --window ${cfgmouse.window} --battery-icons ${cfgmouse.batteryIcons} ${cfgmouse.extraArgs}";
          Restart = "on-failure";
          RestartSec = "5";
        };
      };
    })

    (lib.mkIf cfgqmk.enable {
      environment.systemPackages = [ cfgqmk.package (lib.mkIf cfgqmk.via.enable cfgqmk.via.package) ];
      hardware.keyboard.qmk.enable = true; # enable non-root user to access keyboard configs via QMK
      services.udev.packages = lib.mkIf cfgqmk.via.enable [ cfgqmk.via.package ];
    })
  ];
}

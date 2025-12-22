{ config, lib, pkgs, ... }:
let
  cfgmouse = config.features.mouse;
  cfgqmk = config.features.qmk;
in {
  options.features.mouse = {
    enable = lib.mkEnableOption "enable a mouse remapper + dpi management tool (via solaar)" // { default = true; };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.solaar;
      defaultText = lib.literalExpression "pkgs.solaar";
      description = "The solaar package to use";
    };
    window = lib.mkOption {
      type = lib.types.enum [ "show" "hide" "only" ];
      default = "hide";
      description = ''
        Start with window showing / hidden / only (no tray icon)
      '';
    };
    batteryIcons = lib.mkOption {
      type = lib.types.enum [ "regular" "symbolic" "solaar" ];
      default = "regular";
      description = ''
        Prefer regular battery / symbolic battery / solaar icons
      '';
    };
    extraArgs = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "--restart-on-wake-up";
      description = ''
        Extra arguments to pass to Solaar
      '';
    };
  };
  options.features.qmk = {
    enable = lib.mkEnableOption "enable QMK firmware flasher / tool" // { default = true; };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.qmk;
      defaultText = lib.literalExpression "pkgs.qmk";
      description = "The qmk package to use";
    };
    via = {
      enable = lib.mkEnableOption "enable VIA, a firmware loader without need for flashing" // { default = true; };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.via;
        defaultText = lib.literalExpression "pkgs.via";
        description = "The via package to use";
      };
    };
  };

  config = lib.mkIf cfgmouse.enable {
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
  } // lib.mkIf cfgqmk.enable {
    environment.systemPackages = [ cfgqmk.package (lib.mkIf cfgqmk.via.enable cfgqmk.via.package) ];
    hardware.keyboard.qmk.enable = true; # enable non-root user to access keyboard configs via QMK
    services.udev.packages = lib.mkIf cfgqmk.via.enable [ cfgqmk.via.package ];
  } // {
    # Boot (load usb kernel modules, explicitly)
    boot.kernelModules = [ "usb" "xhci_hdc" ];
    # Disable autosuspend usb devices
    boot.kernelParams = ["usbcore.autosuspend=-1"];
  };
}

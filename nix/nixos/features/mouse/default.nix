{ config, lib, pkgs, nixType, ... }:
let
  cfg = config.${nixType}.mouse;
in {
  options.${nixType}.mouse = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable a mouse remapper + dpi management tool";
    };
				package = lib.mkOption {
						type = lib.types.package;
						default = pkgs.solaar;
						defaultText = lib.literalExpression "pkgs.solaar";
						description = "The mouse remapper tool to use";
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

  config = lib.mkIf cfg.enable {
				environment.systemPackages = [ cfg.package ];
				hardware.logitech.wireless.enable = true;
				hardware.logitech.wireless.enableGraphical = false;

				systemd.user.services.solaar = {
      description = "Solaar, the open source driver for Logitech devices";
      wantedBy = [ "graphical-session.target" ];
      after = [ "dbus.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${cfg.package}/bin/solaar --window ${cfg.window} --battery-icons ${cfg.batteryIcons} ${cfg.extraArgs}";
        Restart = "on-failure";
        RestartSec = "5";
      };
    };
  };
}

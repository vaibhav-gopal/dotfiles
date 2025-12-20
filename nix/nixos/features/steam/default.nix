{ config, lib, ... }:
let
  cfg = config.features.steam;
in {
  options.features.steam = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable steam application";
    };
  };

  config = lib.mkIf cfg.enable {
		programs.steam = {
				enable = true;
				remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		};
  };
}

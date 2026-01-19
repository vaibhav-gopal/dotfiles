{ config, lib, usrlib, ... }:
let
  cfg = config.modules.steam;
in {
  options.modules.steam = {
    enable = usrlib.mkEnableOptionTrue "enable steam application";
  };

  config = lib.mkIf cfg.enable {
		programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		};
  };
}

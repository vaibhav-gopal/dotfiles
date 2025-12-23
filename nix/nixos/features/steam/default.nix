{ config, lib, usrlib, ... }:
let
  cfg = config.features.steam;
in {
  options.features.steam = {
    enable = usrlib.mkEnableOptionTrue "enable steam application";
  };

  config = lib.mkIf cfg.enable {
		programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		};
  };
}

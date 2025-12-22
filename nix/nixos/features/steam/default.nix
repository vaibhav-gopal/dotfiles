{ config, lib, ... }:
let
  cfg = config.features.steam;
in {
  options.features.steam = {
    enable = lib.mkEnableOption "enable steam application" // { default = true; };
  };

  config = lib.mkIf cfg.enable {
		programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		};
  };
}

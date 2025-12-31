{ config, pkgs, lib, usrlib, ... }:
let
  cfg = config.features.airplay;
in {
  options.features.airplay = {
    enable = usrlib.mkEnableOptionTrue "enable airplay via avahi and uxplay";
  };

  config = lib.mkIf cfg.enable {
    # Open network ports
    networking.firewall.allowedTCPPorts = [ 7000 7001 ];
    networking.firewall.allowedUDPPorts = [ 5353 6000 6001 7011 ];

    # To enable network-discovery
    services.avahi = {
      enable = true;
      nssmdns4 = true; # printing services
      openFirewall = true; # ensuring that firewall ports are open as needed
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
        userServices = true;
        domain = true;
      };
    };

    # install uxplay package
    environment.systemPackages = [
      pkgs.uxplay
    ];
  };
}
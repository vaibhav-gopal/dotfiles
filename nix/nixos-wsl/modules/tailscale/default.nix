# Tailscale for NixOS-WSL: the distro joins the tailnet as its own node
# (separate from the Windows host), so it is reachable by MagicDNS name and
# can accept Tailscale SSH. First join is interactive: `sudo tailscale up --ssh`.
{ config, lib, usrlib, ... }:
let
  cfg = config.modules.tailscale;
in {
  options.modules.tailscale = {
    enable = usrlib.mkEnableOptionFalse "Enable tailscaled in this WSL distro";
    ssh = usrlib.mkEnableOptionTrue "Advertise Tailscale SSH (applied on `tailscale up`)";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      extraUpFlags = lib.optionals cfg.ssh [ "--ssh" ];
    };

    # Trust traffic arriving over the tailnet.
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
  };
}

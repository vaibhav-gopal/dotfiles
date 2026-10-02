{ ... }:
{
  imports = [
  ];

  # Joins the tailnet as its own node `vgwsl2` (the Windows host is vghydra).
  modules.tailscale.enable = true;
}

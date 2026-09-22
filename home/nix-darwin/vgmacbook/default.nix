{ ... }:
{
  common.claude-code = {
    profiles = [ "personal" "work" ];
    defaultProfile = "personal";
  };

  common.freerdp.enable = true;
  nixtype.tailscale.enable = true;
}

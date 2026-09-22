{ config, ... }:
{
  common.claude-code = {
    profiles = [ "personal" "work" ];
    defaultProfile = "personal";
  };

  common.freerdp = {
    enable = true;
    defaultArgs = [
      "/dynamic-resolution"
      "+clipboard"
      "/sound:sys:mac"
      "/gfx:AVC444"
      "/network:auto"
      "/drive:mac,${config.home.homeDirectory}/Shared" # mac folder as a drive in windows
    ];
    hosts = {
      vghydra = { user = "vaibhav"; }; # -> rdp-vghydra
    };
  };

  nixtype.tailscale.enable = true;
}

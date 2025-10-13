{ ... }:

{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      ServerAliveInterval 30
      ServerAliveCountMax 30
    '';
  };
}

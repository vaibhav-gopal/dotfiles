{ ... }:

{
  programs.ssh = {
    enable = true;
    extraConfig = 
      "ServerAliveInterval 30\n" +
      "ServerAliveCountMax 30\n";
  };
}

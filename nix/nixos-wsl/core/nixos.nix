{ version, username, hostname, ... }:
{
  system.stateVersion = version;
  wsl.enable = true;
  wsl.defaultUser = username;
  networking.hostName = hostname;
}
{ config, lib, username, hostname, version, ... }:
{
  imports = [
    ./env.nix
  ];

  system.stateVersion = version;
  wsl.enable = true;
  wsl.defaultUser = username;
  networking.hostName = hostname;
}

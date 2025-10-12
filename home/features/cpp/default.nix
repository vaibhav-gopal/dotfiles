{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    gnumake
    cmake
    gdb
    pkg-config
  ];
}

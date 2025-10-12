{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    g++
    gnumake
    cmake
    gdb
    pkg-config
  ];
}

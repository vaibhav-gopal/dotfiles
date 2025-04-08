{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    g++
    clang
    llvm
    gnumake
    cmake
    gdb
    pkg-config
  ];
}

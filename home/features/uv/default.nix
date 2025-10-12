{ config, pkgs, ... }:

{
  # Enable UV support (uv is a python version and package manager ; fully featured with virtual environments and etc...)
  programs.uv.enable = true;
  # see https://docs.astral.sh/uv/reference/settings/ for more info
  programs.uv.settings = {
    
  };
}
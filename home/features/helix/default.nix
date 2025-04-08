{ config, pkgs, lib, modeConfig, hmPaths, ... }:

{
  # Install Helix editor
  home.packages = [
    pkgs.helix
  ];

  # Optionally configure environment variables or aliases here
  # home.sessionVariables.EDITOR = "hx";
  # programs.helix.enable = true; # only if using community modules
}


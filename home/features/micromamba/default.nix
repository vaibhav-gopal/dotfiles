{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.micromamba
  ];

  # Optional: Set the environment base location
  home.sessionVariables = {
    MAMBA_ROOT_PREFIX = "${config.home.homeDirectory}/.micromamba";
  };
}


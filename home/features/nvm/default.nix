{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.nvm
  ];

  home.sessionVariables = {
    NVM_DIR = "${config.home.homeDirectory}/.nvm";
  };
}

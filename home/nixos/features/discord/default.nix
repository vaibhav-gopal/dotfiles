{ config, lib, pkgs, usrlib, ... }:
let
  cfg = config.system.features.discord;
in {
  # MODULE OPTIONS DECLARATION
  options.system.features.discord = {
    enable = usrlib.mkEnableOptionTrue "Enable discord client";
    package = usrlib.mkPackageOption "Discord client package to use" pkgs.discord;
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}

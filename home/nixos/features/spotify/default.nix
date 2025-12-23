{ config, lib, pkgs, usrlib, ... }:
let
  cfg = config.system.features.spotify;
in {
  # MODULE OPTIONS DECLARATION
  options.system.features.spotify = {
    enable = usrlib.mkEnableOptionTrue "Enable spotify client";
    package = usrlib.mkPackageOption "The spotify client package to use" pkgs.spotify;
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}

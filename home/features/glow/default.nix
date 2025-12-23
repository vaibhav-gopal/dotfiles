{ config, lib, pkgs, usrlib, ... }:

let 
  cfg = config.features.glow;
in {
  options.features.glow = {
    enable = usrlib.mkEnableOptionTrue "Enable glow markdown CLI viewer";
    package = usrlib.mkPackageOption "The glow package to use" pkgs.glow;
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.shellAliases = {
      mdp = "glow";
    };
  };
}
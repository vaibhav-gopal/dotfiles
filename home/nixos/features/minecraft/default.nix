{ config, lib, pkgs, usrlib, ... }:
let
  cfg = config.system.features.minecraft;
in {
  # MODULE OPTIONS DECLARATION
  options.system.features.minecraft = {
    enable = usrlib.mkEnableOptionTrue "Enable prism launcher for minecraft";
    package = usrlib.mkPackageOption "The prism launcher package for minecraft" pkgs.prismlauncher;
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}

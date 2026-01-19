{ config, lib, pkgs, usrlib, ... }:
let
  cfg = config.nixtype.minecraft;
in {
  # MODULE OPTIONS DECLARATION
  options.nixtype.minecraft = {
    enable = usrlib.mkEnableOptionTrue "Enable prism launcher for minecraft";
    package = usrlib.mkPackageOption "The prism launcher package for minecraft" pkgs.prismlauncher;
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}

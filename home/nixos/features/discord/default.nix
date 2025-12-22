{ config, lib, pkgs, ... }:
let
  cfg = config.system.features.discord;
in {
  # MODULE OPTIONS DECLARATION
  options.system.features.discord = {
    enable = lib.mkEnableOption "Enable discord client" // { default = true; };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.discord;
      defaultText = lib.literalExpression "pkgs.discord";
      description = "Discord client package to use";
    };
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}

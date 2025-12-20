{ config, lib, pkgs, nixType, ... }:
let
  cfg = config.${nixType}.features.discord;
in {
  # MODULE OPTIONS DECLARATION
  options.${nixType}.features.discord = {
    enable = lib.mkEnableOption "Enable discord client";
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

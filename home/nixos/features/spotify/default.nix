{ config, lib, pkgs, nixType, ... }:
let
  cfg = config.${nixType}.features.spotify;
in {
  # MODULE OPTIONS DECLARATION
  options.${nixType}.features.spotify = {
    enable = lib.mkEnableOption "Enable spotify client";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.spotify;
      defaultText = lib.literalExpression "pkgs.spotify";
      description = "The spotify client package to use";
    };
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}

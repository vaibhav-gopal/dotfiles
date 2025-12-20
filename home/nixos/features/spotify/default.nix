{ config, lib, pkgs, ... }:
let
  cfg = config.system.features.spotify;
in {
  # MODULE OPTIONS DECLARATION
  options.system.features.spotify = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable spotify client";
    };
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

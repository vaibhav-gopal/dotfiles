{ config, lib, pkgs, nixType, ... }:
let
  cfg = config.${nixType}.minecraft;
in {
  # MODULE OPTIONS DECLARATION
  options.${nixType}.minecraft = {
    enable = lib.mkEnableOption "Enable prism launcher for minecraft";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.prismlauncher;
      defaultText = lib.literalExpression "pkgs.prismlauncher";
      description = "The prism launcher package for minecraft";
    };
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}

{ config, lib, pkgs, ... }:
let
  cfg = config.system.features.minecraft;
in {
  # MODULE OPTIONS DECLARATION
  options.system.features.minecraft = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable prism launcher for minecraft";
    };
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

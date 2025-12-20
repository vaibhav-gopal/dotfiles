{ config, lib, pkgs, ... }:

let 
  cfg = config.features.glow;
in {
  options.features.glow = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable glow markdown CLI viewer";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.glow;
      defaultText = lib.literalExpression "pkgs.glow";
      description = "The glow package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.shellAliases = {
      mdp = "glow";
    };
  };
}
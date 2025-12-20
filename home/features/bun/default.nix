{ config, lib, pkgs, ... }:

let 
  cfg = config.features.bun;
in {
  options.features.bun = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the bun program.";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bun;
      defaultText = lib.literalExpression "pkgs.bun";
      description = "The bun package to use";
    };
    settings = lib.mkOption {
      default = {};
      example = {
        telemetry = false;
      };
      type = lib.types.attrsOf lib.types.anything;
      description = ''
        Extra toml settings for $XDG_CONFIG_HOME/.bunfig.toml
        All in TOML via nix attribute sets
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bun.enable = true;
    programs.bun.package = cfg.package;
    programs.bun.settings = cfg.settings;
  };
}

{ config, lib, pkgs, ... }:

let 
  cfg = config.features.uv;
in {
  options.features.uv = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable uv : python env manager";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.uv;
      defaultText = lib.literalExpression "pkgs.uv";
      description = "The uv package to use";
    };
    settings = lib.mkOption {
      default = {};
      type = lib.types.attrsOf lib.types.anything;
      description = ''
        Extra toml settings for $XDG_CONFIG_HOME/uv/uv.toml
        All in TOML via nix attribute sets
        See https://docs.astral.sh/uv/configuration/files/ and https://docs.astral.sh/uv/reference/settings/ for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.uv.enable = true;
    programs.uv.package = cfg.package;
    programs.uv.settings = cfg.settings;
  };
}
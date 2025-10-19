{ config, lib, pkgs, ... }:

let 
  cfg = config.features.ssh;
in {
  options.features.ssh = {
    enable = lib.mkEnableOption "Enable ssh configuration";
    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.openssh;
      defaultText = lib.literalExpression "pkgs.openssh";
      description = "The ssh package to use ; if null, uses system package (was default)";
    };
    extraConfig = lib.mkOption {
      default = ''
        ServerAliveInterval 30
        ServerAliveCountMax 30
      '';
      type = lib.types.lines;
      description = ''
        Extra configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      package = cfg.package;
      extraConfig = cfg.extraConfig;
    };
  };
}
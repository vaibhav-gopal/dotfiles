{ config, lib, pkgs, ... }:

let
  cfg = config.features.java;
in {
  options.features.java = {
    enable = lib.mkEnableOption "Enable the java development kit (JDK) and/or java runtime environment (JRE)" // { default = true; };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.temurin-bin;
      defaultText = lib.literalExpression "pkgs.temurin-bin";
      description = "The java runtime package";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.java.enable = true;
    programs.java.package = cfg.package;
  };
}

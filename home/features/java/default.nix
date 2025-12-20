{ config, lib, pkgs, ... }:

let
  cfg = config.features.java;
in {
  # MODULE OPTIONS DECLARATION
  options.features.java = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the java development kit (JDK) and/or java runtime environment (JRE)";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.temurin-bin;
      defaultText = lib.literalExpression "pkgs.temurin-bin";
      description = "The java runtime package";
    };
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    programs.java.enable = true;
    programs.java.package = cfg.package;
  };
}

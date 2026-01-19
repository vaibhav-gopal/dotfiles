{ config, lib, pkgs, usrlib, ... }:

let
  cfg = config.common.java;
in {
  options.common.java = {
    enable = usrlib.mkEnableOptionTrue "Enable the java development kit (JDK) and/or java runtime environment (JRE)";
    package = usrlib.mkPackageOption "The java runtime package" pkgs.temurin-bin;
  };

  config = lib.mkIf cfg.enable {
    programs.java.enable = true;
    programs.java.package = cfg.package;
  };
}

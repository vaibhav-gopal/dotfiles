{ config, lib, pkgs-unstable, usrlib, ... }:
let
  cfg = config.nixtype.vscode;
in {
  # MODULE OPTIONS DECLARATION
  options.nixtype.vscode = {
    enable = usrlib.mkEnableOptionTrue "Enable vscode application";
    package = usrlib.mkPackageOption "The vscode package to use" pkgs-unstable.vscode;
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
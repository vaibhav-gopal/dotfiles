{ config, lib, pkgs-unstable, ... }:
let
  cfg = config.system.features.vscode;
in {
  # MODULE OPTIONS DECLARATION
  options.system.features.vscode = {
    enable = lib.mkEnableOption "Enable vscode application" // { default = true; };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs-unstable.vscode;
      defaultText = lib.literalExpression "pkgs-unstable.vscode";
      description = "The vscode package to use";
    };
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
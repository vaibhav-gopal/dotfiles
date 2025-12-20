{ config, lib, pkgs, nixType, ... }:
let
  cfg = config.${nixType}.features.vscode;
in {
  # MODULE OPTIONS DECLARATION
  options.${nixType}.features.vscode = {
    enable = lib.mkEnableOption "Enable vscode application";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.vscode;
      defaultText = lib.literalExpression "pkgs.vscode";
      description = "The vscode package to use";
    };
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}

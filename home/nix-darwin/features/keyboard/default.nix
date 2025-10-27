{ config, lib, ... }:

let
  cfg = config.darwin.features.keyboard;
  bundlePath = ./VaibhavsCustomKeylayout.keylayout;
  layoutsPath = "${config.home.homeDirectory}/Library/Keyboard\ Layouts/VaibhavsCustomKeylayout.keylayout";
in {
  options.darwin.features.keyboard = {
    enable = lib.mkEnableOption "Enable darwin keyboard";

    bundlePath = lib.mkOption {
      type = lib.types.path;
      default = bundlePath;
      defaultText = lib.literalExpression "./VaibhavsCustomKeylayout.keylayout";
      description = "The location for the macos keyboard bundle or keylayout to install to the system (via symlink to ~/Library/Keyboard\ Layouts)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.${layoutsPath}.source = cfg.bundlePath;
  };
}
{ config, lib, ... }:

let
  cfg = config.darwin.features.keyboard;
  bundlePath = ./DarwinKeyboards_Vaibhav.bundle;
  layoutsPath = "${config.home.homeDirectory}/Library/Keyboard\ Layouts/DarwinKeyboardVaibhav.bundle";
in {
  options.darwin.features.keyboard = {
    enable = lib.mkEnableOption "Enable darwin keyboard";

    bundlePath = lib.mkOption {
      type = lib.types.path;
      default = bundlePath;
      defaultText = lib.literalExpression "./DarwinKeyboards_Vaibhav.bundle";
      description = "The location for the macos keyboard bundle to install to the system (via symlink to ~/Library/Keyboard\ Layouts)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.${layoutsPath}.source = cfg.bundlePath;
  };
}
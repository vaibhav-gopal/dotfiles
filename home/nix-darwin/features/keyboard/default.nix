{ config, lib, ... }:

let
  cfg = config.darwin.features.keyboard;
  bundlePath = ./VaibhavMacKeyboardLayouts.bundle;
  layoutsPath = "${config.home.homeDirectory}/Library/Keyboard\ Layouts/VaibhavMacKeyboardLayouts.bundle";
  layoutsPath_Raw = "$HOME/Library/Keyboard\ Layouts/";
in {
  options.darwin.features.keyboard = {
    enable = lib.mkEnableOption "Enable darwin keyboard";

    bundlePath = lib.mkOption {
      type = lib.types.path;
      default = bundlePath;
      defaultText = lib.literalExpression "./VaibhavMacKeyboardLayouts.bundle";
      description = "The location for the macos keyboard bundle or keylayout to install to the system (by copying the file, replacing any file with the same name)";
    };
  };

  config = lib.mkIf cfg.enable {
    # For symlink (doesn't work)
    # home.file.${layoutsPath}.source = cfg.bundlePath;

    # For copying the file
    system.activationScripts.copyMyFiles = {
    deps = [ "users" ]; 
    text = ''
      # Create the target directory if it doesn't exist
      mkdir -p ${layoutsPath_Raw}

      # Copy files from a source in your Nix store to the destination
      cp -rf ${bundlePath} /path/to/destination/directory/
    '';
  };
  };
}
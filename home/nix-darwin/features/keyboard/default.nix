{ config, lib, usrlib, ... }:

let
  cfg = config.system.features.keyboard;
  bundlePath = "${config.extPaths.nixFeaturesTypeDir}/keyboard/VaibhavMacKeyboardLayouts";
  layoutsPath = "${config.home.homeDirectory}/Library/Keyboard\ Layouts/";
  layoutsDirPath = "${config.home.homeDirectory}/Library/Keyboard\ Layouts/";
in {
  options.system.features.keyboard = {
    enable = usrlib.mkEnableOptionTrue "Enable darwin keyboard";
    bundlePath = usrlib.mkPathOption "The location for the macos keyboard bundle or keylayout to install to the system (by copying the file, replacing any file with the same name)" bundlePath;
  };

  config.home.activation.copyKeyboardLayoutBundle = lib.mkIf cfg.enable ( 
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Create the target directory if it doesn't exist
      mkdir -p ${layoutsDirPath}

      # Copy files from a source in your Nix store to the destination
      cp -rf ${bundlePath} ${layoutsPath}
    ''
  );
}

{ config, lib, usrlib, pkgs-unstable, ... }:
let
  cfg = config.features.vivaldi;
in {
  options.features.vivaldi = {
    enable = usrlib.mkEnableOptionTrue "enable vivaldi browser";
    package = usrlib.mkPackageOption "The vivaldi package to use" pkgs-unstable.vivaldi;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (cfg.package.overrideAttrs
      (oldAttrs: {
        # To fix startup on plasma6 (KDE) due to improper packaging :(
        dontWrapQtApps = false;
        dontPatchELF = true;
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs-unstable.kdePackages.wrapQtAppsHook];

        proprietaryCodecs = true; 
        enableWidevine = true; # Google's DRM (digital rights management ; netflix, prime video, etc...)
      }))
    ];
  };
}

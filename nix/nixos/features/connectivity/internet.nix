{ config, lib, ... }:
let
  cfg = config.feature.internet;
in {
  options.features.internet = {
    enable = lib.mkEnableOption "enable internet configuration" // { default = true; };
    method = lib.mkOption {
      type = lib.types.enum [ "networkmanager" "wpa_supplicant"];
      default = "networkmanager";
      description = "Method to enable internet connection. (wpa_supplicant for non desktop environments)";
    };
  };

  config = lib.mkIf cfg.enable (
    if cfg.method == "networkmanager" then {
      # Enable networking via networkmanager
      networking.networkmanager.enable = true;
    } else if cfg.method == "wpa_supplicant" then {
      # Enables wireless support via wpa_supplicant.
      networking.wireless.enable = true;
    } else {}
  );
}
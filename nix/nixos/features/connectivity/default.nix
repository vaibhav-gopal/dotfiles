{ config, lib, ... }:
let
  cfginternet = config.features.internet;
  cfgbluetooth = config.features.bluetooth;
  cfgprinting = config.features.printing;
in {
  options.features.internet = {
    enable = lib.mkEnableOption "enable internet configuration" // { default = true; };
    method = lib.mkOption {
      type = lib.types.enum [ "networkmanager" "wpa_supplicant"];
      default = "networkmanager";
      description = "Method to enable internet connection. (wpa_supplicant for non desktop environments)";
    };
  };
  options.features.bluetooth = {
    enable = lib.mkEnableOption "enable bluetooth configuration" // { default = true; };
  };
  options.features.printing = {
    enable = lib.mkEnableOption "enable printing documents via CUPS" // { default = true; };
  };

  config = lib.mkMerge [
    # Handle NetworkManager
    (lib.mkIf (cfginternet.enable && cfginternet.method == "networkmanager") {
      # Enable networking via networkmanager
      networking.networkmanager.enable = true;
    })
    # Handle wpa_supplicant
    (lib.mkIf (cfginternet.enable && cfginternet.method == "wpa_supplicant") {
      # Enables wireless support via wpa_supplicant.
      networking.wireless.enable = true;
    })

    (lib.mkIf cfgbluetooth.enable {
      # Enable bluetooth
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      # Boot (load bluetooth kernel modules, explicitly)
      boot.kernelModules = ["btusb" "bluetooth"];
    })

    (lib.mkIf cfgprinting.enable {
      # Enable CUPS to print documents.
      services.printing.enable = true;
    })
  ];
}

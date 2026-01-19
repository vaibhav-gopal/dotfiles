{ config, lib, usrlib, ... }:
let
  cfginternet = config.core.internet;
  cfgbluetooth = config.core.bluetooth;
  cfgprinting = config.core.printing;
in {
  options.core.internet = {
    enable = usrlib.mkEnableOptionTrue "enable internet configuration";
    method = usrlib.mkEnumOption
      "Method to enable internet connection. (wpa_supplicant for non desktop environments)" 
      "networkmanager" 
      [ "networkmanager" "wpa_supplicant" ];
  };
  options.core.bluetooth = {
    enable = usrlib.mkEnableOptionTrue "enable bluetooth configuration";
  };
  options.core.printing = {
    enable = usrlib.mkEnableOptionTrue "enable printing documents via CUPS";
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
      hardware.bluetooth.settings = {
        General = {
          Experimental = true; # Helps with newer BT protocols and implementations
        };
      };
      # Boot (load bluetooth kernel modules, explicitly)
      boot.kernelModules = ["btusb" "bluetooth"];
    })

    (lib.mkIf cfgprinting.enable {
      # Enable CUPS to print documents.
      services.printing.enable = true;
    })
  ];
}

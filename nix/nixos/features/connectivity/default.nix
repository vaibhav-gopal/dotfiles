{ config, lib, ... }:
let
  cfginternet = config.features.internet;
  cfgbluetooth = config.features.bluetooth;
  cfgprinting = config.features.printing;
in {
  imports = [
    ./internet.nix
  ];
  options.features.bluetooth = {
    enable = lib.mkEnableOption "enable bluetooth configuration" // { default = true; };
  };
  options.features.printing = {
    enable = lib.mkEnableOption "enable printing documents via CUPS" // { default = true; };
  };

  config = lib.mkMerge [
    # (lib.mkIf cfginternet.enable (
    #   if cfginternet.method == "networkmanager" then {
    #     # Enable networking via networkmanager
    #     networking.networkmanager.enable = true;
    #   } else if cfginternet.method == "wpa_supplicant" then {
    #     # Enables wireless support via wpa_supplicant.
    #     networking.wireless.enable = true;
    #   } else {}
    # ))
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

  # config = lib.mkIf cfginternet.enable (
  #   if cfginternet.method == "networkmanager" then {
  #     # Enable networking via networkmanager
  #     networking.networkmanager.enable = true;
  #   } else if cfginternet.method == "wpa_supplicant" then {
  #     # Enables wireless support via wpa_supplicant.
  #     networking.wireless.enable = true;
  #   } else {}
  # ) // lib.mkIf cfgbluetooth.enable {
  #   # Enable bluetooth
  #   hardware.bluetooth.enable = true;
  #   hardware.bluetooth.powerOnBoot = true;
  #   # Boot (load bluetooth kernel modules, explicitly)
  #   boot.kernelModules = ["btusb" "bluetooth"];
  # } // lib.mkIf cfgprinting.enable {
  #   # Enable CUPS to print documents.
  #   services.printing.enable = true;
  # };
}

{ config, pkgs, ...}:
{
  # cannot enable this, if networkmanager is enabled
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Boot (load usb / bluetooth kernel modules, explicitly)
  boot.kernelModules = [ "usb" "xhci_hdc" "btusb" "bluetooth"];

  # Disable autosuspend usb devices
  boot.kernelParams = ["usbcore.autosuspend=-1"];
}


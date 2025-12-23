{ config, lib, usrlib, pkgs, ... }:
let
  cfgboot = config.core.boot;
in {
  options.core.boot = {
    enable = usrlib.mkEnableOptionTrue "enable boot config";
    kernel = usrlib.mkEnumOption "The linux kernel version" "latest" [ "default" "latest"];
    bootloader = usrlib.mkEnumOption "The system bootloader" "systemd" [ "grub" "systemd"];
    plymouth = {
      enable = lib.mkEnableOptionTrue "enable boot config";
    };
  };

  config = lib.mkMerge [

    (lib.mkIf (cfgboot.enable && cfgboot.kernel == "default") {
    })
    (lib.mkIf (cfgboot.enable && cfgboot.kernel == "latest") {
      boot.kernelPackages = pkgs.linuxPackages_latest; # latest linux kernel (default is LTS)
    })
    (lib.mkIf (cfgboot.enable && cfgboot.bootloader == "grub") {
    })
    (lib.mkIf (cfgboot.enable && cfgboot.bootloader == "systemd") {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    })
    (lib.mkIf cfgboot.enable {
      # Boot (load usb kernel modules, explicitly)
      boot.kernelModules = [ "xhci_hcd" ];
      # Disable autosuspend usb devices
      boot.kernelParams = ["usbcore.autosuspend=-1"];
      # Enable all firmware on device to be loaded
      hardware.enableAllFirmware = true;
    })
  ];
}
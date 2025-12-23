{ config, lib, pkgs, ... }:
let
  cfgboot = config.core.boot;
in {
  options.core.boot = {
    enable = lib.mkEnableOption "enable boot config" // { default = true; };
    kernel = lib.mkOption {
      type = lib.types.enum [ "default" "latest"];
      default = "latest";
      description = "The linux kernel version";
    };
    bootloader = lib.mkOption {
      type = lib.types.enum [ "grub" "systemd"];
      default = "systemd";
      description = "The system bootloader";
    };
    plymouth = {
      enable = lib.mkEnableOption "enable boot config" // { default = true; };
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
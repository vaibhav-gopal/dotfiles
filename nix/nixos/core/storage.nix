{ config, lib, usrlib, pkgs, ... }:
let
  cfg = config.core.storage;
in {
  options.core.storage = {
    enable = usrlib.mkEnableOptionTrue "enable core storage configuration packages";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [
        pkgs.exfatprogs # provides: mkfs.exfat, ...
        pkgs.gparted # provides: gparted (graphical disk utility application)
        pkgs.gptfdisk # provides: gdisk (GPT partition tables)
        # pkgs.fdisk # provides: fdisk (MBR partition tables, provided by nix by default)
      ];
    };
  };
}

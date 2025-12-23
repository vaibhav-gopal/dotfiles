{ config, lib, usrlib, specialArgs, username, ... }:
let
  cfg = config.core.home;
in {
  options.core.home = {
    enable = usrlib.mkEnableOptionTrue "enable nixos-wsl home-manager configuration";
  };
  config = lib.mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = specialArgs;
    home-manager.backupFileExtension = "backup-before-home-manager-nixos-wsl";
    home-manager.users.${username} = import ../../../home/home.nix;
  };
}

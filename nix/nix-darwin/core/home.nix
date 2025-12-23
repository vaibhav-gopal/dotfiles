{ config, lib, usrlib, specialArgs, username, ... }:
let
  cfg = config.core.home;
in {
  options.core.home = {
    enable = usrlib.mkEnableOptionTrue "enable darwin home-manager configuration";
  };

  config = lib.mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = specialArgs;
    home-manager.backupFileExtension = "backup-before-nix-darwin";
    home-manager.users.${username} = import ../../../home/home.nix;
  };
}

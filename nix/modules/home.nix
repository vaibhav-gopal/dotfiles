{ config, lib, usrlib, specialArgs, username, ... }:
let
  cfg = config.core.home;
in {
  options.core.home = {
    enable = usrlib.mkEnableOptionTrue "enable home-manager configuration";
  };

  config = lib.mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = specialArgs // { inherit usrlib; };
    home-manager.backupFileExtension = "backup-before-home-manager";
    home-manager.users.${username} = import ../../home/default.nix;
  };
}

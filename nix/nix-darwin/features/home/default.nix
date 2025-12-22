{ config, lib, specialArgs, username, ... }:
let
  cfg = config.features.home;
in {
  options.features.home = {
    enable = lib.mkEnableOption "enable darwin home-manager configuration" // { default = true; };
  };

  config = lib.mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = specialArgs;
    home-manager.backupFileExtension = "backup-before-nix-darwin";
    home-manager.users.${username} = import ../../../../home/home.nix;
  };
}

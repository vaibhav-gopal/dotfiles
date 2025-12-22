{ config, lib, specialArgs, username, ... }:
let
  cfg = config.features.home-manager;
in {
  options.features.home-manager = {
    enable = lib.mkEnableOption "enable nixos-wsl home-manager configuration" // { default = true; };
  };
  config = lib.mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = specialArgs;
    home-manager.backupFileExtension = "backup-before-home-manager-nixos-wsl";
    home-manager.users.${username} = import ../../../../home/home.nix;
  };
}

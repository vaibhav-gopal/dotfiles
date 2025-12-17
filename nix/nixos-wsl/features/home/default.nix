{ config, lib, specialArgs, username, ... }:
let
  cfg = config.wsl.home-manager;
in {
  options.wsl.home-manager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable nixos-wsl home-manager configuration";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = specialArgs;
    home-manager.backupFileExtension = "backup-before-home-manager-nixos-wsl";
    home-manager.users.${username} = import ../../../../home/home.nix;
  };
}

{ config, lib, specialArgs, username, ... }:
let
  cfg = config.nixos.home;
in {
  options.nixos.home = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable nixos home-manager configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = specialArgs;
    home-manager.backupFileExtension = "backup-before-nixos-home-manager";
    home-manager.users.${username} = import ../../../../home/home.nix;
  };
}

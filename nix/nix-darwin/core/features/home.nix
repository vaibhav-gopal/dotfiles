{ config, lib, specialArgs, username, ... }:
let
  cfg = config.darwin.home-manager;
in {
  options.darwin.home-manager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable darwin home-manager configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = specialArgs;
    home-manager.backupFileExtension = "backup-before-nix-darwin";
    home-manager.users.${username} = import ../../../home/home.nix;
  };
}
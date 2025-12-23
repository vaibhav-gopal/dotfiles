{ config, lib, specialArgs, username, ... }:
let
  cfg = config.core.home;
in {
  options.core.home = {
    enable = lib.mkEnableOption "enable nixos home-manager configuration" // { default = true; };
  };

  config = lib.mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = specialArgs;
    home-manager.backupFileExtension = "backup-before-nixos-home-manager";
    home-manager.users.${username} = import ../../../home/home.nix;
  };
}

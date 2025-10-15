{ specialArgs, username, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = specialArgs;
  home-manager.backupFileExtension = "backup-before-home-manager-nixos";
  home-manager.users.${username} = import ../../../home/home.nix;
}
{ config, pkgs, lib, pkgs-unstable, usrlib, ... }:
let 
  cfg = config.core.env;
in {
  options.core.env = {
    enable = usrlib.mkEnableOptionTrue "enable nixos-wsl base environment configurations";
    packages = usrlib.mkListOfPackagesOption "List of packages to install as system packages" [
      # install stable packages ; static, small changes between versions, need stability
      pkgs.wget
      pkgs.vim
      pkgs.git
      # install unstable packages ; need the latest version (bug fixes or etc...)
      pkgs-unstable.just
      pkgs-unstable.nixd
      pkgs-unstable.nil
    ];
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = cfg.packages;
    };

    programs.zsh.enable = true;
    environment.shells = [
      pkgs.zsh
    ];

    # enable running foreign binaries on NixOS (allows vscode server)
    programs.nix-ld.enable = true;
  };
}

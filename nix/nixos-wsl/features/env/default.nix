{ config, pkgs, lib, pkgs-unstable, ... }:
let 
  cfg = config.features.env;
in {
  options.features.env = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable nixos-wsl base environment configurations";
    };
    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [
        # install stable packages ; static, small changes between versions, need stability
        pkgs.wget
        pkgs.vim
        pkgs.git
        # install unstable packages ; need the latest version (bug fixes or etc...)
        pkgs-unstable.just
        pkgs-unstable.nixd
        pkgs-unstable.nil
      ];
      description = "List of packages to install as system packages";
    };
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

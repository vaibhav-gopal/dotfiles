{ config, lib, ... }:
let
  cfg = config.wsl.nix;
in {
  options.darwin.nix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable nixos-wsl nix configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      enable = true;
      settings = {
        # enable flakes globally
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        # substituers that will be considered before the official ones(https://cache.nixos.org)
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        builders-use-substitutes = true;

        auto-optimise-store = true;
        download-buffer-size = 262144000; # 250 MB (250 * 1024 * 1024)
      };

      # do garbage collection weekly to keep disk usage low
      gc = {
        automatic = lib.mkDefault true;
        options = lib.mkDefault "--delete-older-than 7d";
      };
    };
  };
}
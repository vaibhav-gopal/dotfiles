{ config, lib, usrlib, ... }:
let
  cfg = config.core.nix;
in {
  options.core.nix = {
  };

  config = {
    # common nixpkgs configuration
    nixpkgs.config.allowUnfree = true; # allow unfree packages to be installed

    # required general nix configuration
    nix = {
      enable = true;
      settings = {
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

        auto-optimise-store = false; # calls `nix-store --optimize` after every rebuild, slow and not needed
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

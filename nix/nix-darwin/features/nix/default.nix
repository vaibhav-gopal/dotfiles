{ config, lib, ... }:

let
  cfg = config.darwin.nix;
in {
  options.darwin.nix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable darwin nix configuration";
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

        # Disable auto-optimise-store on MacOS because of this issue:
        #   https://github.com/NixOS/nix/issues/7273
        # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
        auto-optimise-store = false;
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
{ config, lib, pkgs, ... }:
{
  nix = {
    enable = true;
    package = pkgs.nix;
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
    };

    # do garbage collection weekly to keep disk usage low
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  environment = {
    # install base packages
    systemPackages = with pkgs; [
      wget
      vim
      git
      go-task # like make but simpler : https://taskfile.dev/docs/getting-started
    ];

    variables.EDITOR = lib.mkDefault "vim";
    variables.PAGER = lib.mkDefault "less";
    variables.LESS = lib.mkDefault "-FR --mouse";
  };

  # enable running foreign binaries on NixOS (allows vscode server)
  programs.nix-ld.enable = true;
}

{ config, pkgs, lib, modeConfig, hmPaths, ... }:

let
  # Optional additional common modules in this directory
  additionalCommonModules = [
    # ./shell.nix
    # ./git.nix
  ];

  # Define shared packages for all modes
  commonPackages = [
    pkgs.htop
    pkgs.fd
    pkgs.ripgrep
  ];
in
{
  # ─── Core User Configuration ──────────────────────────────────────────────
  home.username = modeConfig.username;
  home.homeDirectory = "/home/${modeConfig.username}";
  home.stateVersion = modeConfig.version;

  # ─── Common Environment Variables ─────────────────────────────────────────
  # mkMerge allows other modules to safely extend this
  home.sessionVariables = lib.mkMerge [
    {
      HM_MODE_NAME = modeConfig.modeName;
      HM_MODE_PATH = modeConfig.modePath;
    }

    # Optionally set default EDITOR, PATH, etc.
    # { EDITOR = lib.mkDefault "hx"; }
  ];

  # ─── Common Package Set ───────────────────────────────────────────────────
  home.packages = commonPackages;

  # ─── Home Manager Self Management ─────────────────────────────────────────
  programs.home-manager = {
    enable = true;
    path = modeConfig.modePath;
  };

  # ─── Optional Common Imports ──────────────────────────────────────────────
  imports = additionalCommonModules;
}


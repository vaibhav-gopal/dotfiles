{ config, pkgs, lib, modeConfig, hmPaths, ... }:

let
  # Optional additional common modules in this directory
  additionalCommonModules = [
    ./shell.nix
    ./git.nix
    ./term.nix
    ./vim.nix
  ];

  # Define shared packages for all modes
  commonPackages = [
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
      HM_MODE_CONFIGS_PATH = modeConfig.modeConfigsPath;
    }

    # Optionally set default EDITOR, PATH, etc.
    {
      EDITOR = lib.mkDefault "vim";
      PAGER = lib.mkDefault "less -FR";
    }

    # Sane defaults
    {
      LESS = lib.mkDefault "--mouse --wheel-lines=3";
    }
  ];

  # ─── Common Package Set ───────────────────────────────────────────────────
  home.packages = commonPackages;

  # --- Common Program Set (managed Packages) --------------------------------
  programs.bat.enable = true;
  programs.bat.config = {
    pager = "less -FR";
    theme = "Monokai Extended";
  };

  programs.eza.enable = true;
  programs.eza.colors = "auto";
  programs.eza.git = true;

  programs.fd.enable = true;

  programs.ripgrep.enable = true;

  programs.htop.enable = true;

  # ─── Home Manager Self Management ─────────────────────────────────────────
  programs.home-manager = {
    enable = true;
  };

  # ─── Optional Common Imports ──────────────────────────────────────────────
  imports = additionalCommonModules;
}


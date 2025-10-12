{ config, pkgs, lib, modeConfig, hmPaths, ... }:

let
  # Optional additional common modules in this directory
  additionalCommonModules = [
    ./shell.nix
    ./git.nix
    ./term.nix
    ./vim.nix
    ./ssh.nix
    ./compression.nix
    ./fonts.nix
  ];

  # Define shared packages for all modes
  commonPackages = [
    pkgs.wget
    pkgs.curl
    pkgs.coreutils
    pkgs.gnused
    pkgs.gawk
    pkgs.gnugrep
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
      LESS = lib.mkDefault "-FR --mouse";
    }
  ];

  # ─── Common Shell Aliases ─────────────────────────────────────────────────
  home.shellAliases = {
    ll = "eza --all --long";
    lt = "eza --all --long --tree";
    llg = "eza --all --long --git";
    ltg = "eza --all --long --tree --git";
    hm = "home-manager";
    hms = "home-manager switch --flake $DOTFILES_DIR#$HM_MODE_NAME";
    hml = "home-manager generations";
    hmpkgs = "home-manager packages";
  };

  # ─── Common Package Set ───────────────────────────────────────────────────
  home.packages = commonPackages;

  # --- Common Program Set (managed Packages) --------------------------------
  # bat : cat alternative
  programs.bat.enable = true;
  programs.bat.config = {
    pager = "less -FR --mouse";
    theme = "Monokai Extended";
  };

  # eza : ls alternative
  programs.eza.enable = true;
  programs.eza.colors = "auto";
  programs.eza.git = true;

  # fd : find alternative
  programs.fd.enable = true;

  # ripgrep : recursive grep
  programs.ripgrep.enable = true;

  # jq : command line json parser
  programs.jq.enable = true;

  # bottom : top/htop alternative (process monitor)
  programs.bottom.enable = true;

  # fzf : fuzzy finder (just a front-end ; need fd or ripgrep to power it)
  programs.fzf.enable = true;
  programs.fzf.defaultCommand = "fd --type f";
  programs.fzf.defaultOptions = ["--height 40%" "--border"];
  programs.fzf.fileWidgetCommand = "fd --type f";
  programs.fzf.fileWidgetOptions = ["--preview 'head {}'"];
  programs.fzf.changeDirWidgetCommand = "fd --type d";
  programs.fzf.changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];

  # fastfetch : the cool display system / arch terminal thing
  programs.fastfetch.enable = true;

  # ─── Home Manager Self Management ─────────────────────────────────────────
  programs.home-manager = {
    enable = true;
  };

  # ─── Optional Common Imports ──────────────────────────────────────────────
  imports = additionalCommonModules;
}


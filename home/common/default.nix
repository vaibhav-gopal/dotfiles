args@{ nixpkgs, lib, username, version, homedirectory, ... }:

let
  # Optional additional common modules in this directory
  additionalCommonModules = [
    (import ./git.nix args)
    (import ./shell.nix args)
    (import ./ssh.nix args)
    (import ./term.nix args)
    (import ./vim.nix args)
  ];

  # Define shared packages
  commonPackages = [
    # networking utils
    nixpkgs.wget
    nixpkgs.curl
    nixpkgs.socat # netcat alternative
    nixpkgs.nmap
    nixpkgs.openssh  # provides ssh, scp, sftp, ssh-keygen, etc.
    nixpkgs.rsync    # for remote and local sync

    # file utils
    nixpkgs.coreutils
    nixpkgs.gnused
    nixpkgs.gawk
    nixpkgs.gnugrep

    # compression / archiving utils
    nixpkgs.zip
    nixpkgs.unzip
    nixpkgs.gzip
    nixpkgs.xz
    nixpkgs.gnutar
  ];
in
{
  # ─── Core User Configuration ──────────────────────────────────────────────
  home.username = username;
  home.homeDirectory = homedirectory;
  home.stateVersion = version;

  # ─── Common Environment Variables ─────────────────────────────────────────
  # mkMerge allows other modules to safely extend this
  home.sessionVariables = lib.mkMerge [
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


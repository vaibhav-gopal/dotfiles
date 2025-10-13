args@{ pkgs, lib, username, version, homedirectory, ... }:

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
    pkgs.wget
    pkgs.curl
    pkgs.socat # netcat alternative
    pkgs.nmap
    pkgs.openssh  # provides ssh, scp, sftp, ssh-keygen, etc.
    pkgs.rsync    # for remote and local sync

    # file utils
    pkgs.coreutils
    pkgs.gnused
    pkgs.gawk
    pkgs.gnugrep

    # compression / archiving utils
    pkgs.zip
    pkgs.unzip
    pkgs.gzip
    pkgs.xz
    pkgs.gnutar
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
    l = "eza --all";
    ll = "eza --all --long";
    lt = "eza --all --long --tree";
    llg = "eza --all --long --git";
    ltg = "eza --all --long --tree --git";
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


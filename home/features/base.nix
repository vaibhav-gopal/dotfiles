{ pkgs, lib, username, version, homedirectory, ... }:

{
  # ─── Core User Configuration ──────────────────────────────────────────────
  programs.home-manager = {
    enable = true;
  };
  home.username = username;
  home.homeDirectory = homedirectory;
  home.stateVersion = version;

  # ─── XDG Base Directories ──────────────────────────────────────────────
  xdg.enable = true;

  # ─── Common Package Set ───────────────────────────────────────────────────
  home.packages = [
    # networking utils
    pkgs.wget
    pkgs.curl
    pkgs.socat # netcat alternative
    pkgs.nmap
    pkgs.rsync # for remote and local sync

    # file utils
    pkgs.coreutils
    # GNU replacements (directly replaces the command name)
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

  # --- Common Program Set (managed Packages) --------------------------------
  # bat : cat alternative
  # available via: `bat`
  programs.bat.enable = true;
  programs.bat.config = {
    pager = "less -FR --mouse";
    theme = "Monokai Extended";
  };

  # eza : ls alternative
  # available via: `eza`
  programs.eza.enable = true;
  programs.eza.colors = "always"; # output color ; even when redirected or piped
  programs.eza.git = true;

  # fd : find alternative
  # available via: `fd`
  programs.fd.enable = true;

  # ripgrep : recursive grep
  # available via: `rg`
  programs.ripgrep.enable = true;

  # jq : command line json parser
  # available via: `jq`
  programs.jq.enable = true;

  # bottom : top/htop alternative (process monitor)
  # available via: `btm`
  programs.bottom.enable = true;

  # fzf : fuzzy finder (just outputs file/folder name; need fd or ripgrep or zoxide to power it via piping or plugins)
  # available via: `fzf`
  programs.fzf.enable = true;
  programs.fzf.defaultCommand = "fd --type f";
  programs.fzf.defaultOptions = ["--height 40%" "--border"];
  programs.fzf.fileWidgetCommand = "fd --type f";
  programs.fzf.fileWidgetOptions = ["--preview 'head {}'"];
  programs.fzf.changeDirWidgetCommand = "fd --type d";
  programs.fzf.changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];

  # zoxide : a better cd command
  # available via: `z` and `zi` with fzf
  programs.zoxide.enable = true;

  # fastfetch : the cool display system / arch terminal thing
  # avalable via `fastfetch`
  programs.fastfetch.enable = true;

  # ─── Common Environment Variables ─────────────────────────────────────────
  home.sessionVariables = {
    PAGER = lib.mkDefault "less -FR";
    LESS = lib.mkDefault "-FR --mouse";
  };

  # ─── Common Shell Aliases ─────────────────────────────────────────────────
  home.shellAliases = {
    l = "eza --all";
    ll = "eza --all --long";
    lt = "eza --all --long --tree --ignore-glob .git --level";
    lg = "eza --all --git-ignore";
    llg = "eza --all --long --git-ignore";
    ltg = "eza --all --long --tree --ignore-glob .git --git-ignore --level";
    cdp = "cd ../"; # to parent directory
    cdb = "cd -"; # to previous directory
    cdd = "cd ~/dotfiles"; # cd to dotfiles directory
  };
}


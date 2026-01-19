{ config, pkgs, lib, pkgs-unstable, usrlib, ... }:
let
  cfg = config.core.env;
in {
  options.core.env = {
    enable = usrlib.mkEnableOptionTrue "enable nixos base environment configurations";
    packages = usrlib.mkListOfPackagesOption "Base list of packages to install as system packages" [
      # install stable packages ; static, small changes between versions, need stability
      pkgs.wget
      pkgs.vim
      pkgs.lshw
      pkgs.usbutils
      # install unstable packages ; need the latest version (bug fixes or etc...)
      pkgs-unstable.just
      pkgs-unstable.nixd
      pkgs-unstable.nil
    ];
    storage = {
      enable = usrlib.mkEnableOptionTrue "enable core storage configuration packages";
      packages = usrlib.mkListOfPackagesOption "Base list of packages to install as system packages" [
        pkgs.exfatprogs # provides: mkfs.exfat, ...
        pkgs.gparted # provides: gparted (graphical disk utility application)
        pkgs.gptfdisk # provides: gdisk (GPT partition tables)
        # pkgs.fdisk # provides: fdisk (MBR partition tables, provided by nix by default)
      ];
    };
    fonts = {
      enable = usrlib.mkEnableOptionTrue "enable font configuration and download";
      packages = usrlib.mkListOfPackagesOption "list of font packages to install" (with pkgs; [
        # icon fonts
        material-design-icons
        font-awesome

        # nerdfonts
        nerd-fonts.symbols-only
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.hack
        nerd-fonts.space-mono
      ]);
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = lib.mkMerge [
        (cfg.packages)
        (lib.mkIf cfg.storage.enable cfg.storage.packages)
      ];
    };

    # enable zsh (but keep bash as login shell)
    programs.zsh.enable = true;
    environment.shells = [
      pkgs.zsh
    ];

    # Some programs need SUID wrappers, can be configured further or are started in user sessions.
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Firefox
    programs.firefox.enable = true;

    # Git
    programs.git.enable = true;

    # Fonts
    fonts = lib.mkIf cfg.fonts.enable {
      packages = cfg.fonts.packages;
    };

    # TIME ZONES
    # Set your time zone.
    time.timeZone = "America/New_York";
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
}

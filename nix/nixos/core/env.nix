{ config, pkgs, lib, pkgs-unstable, ... }:
let
  cfg = config.core.env;
in {
  options.core.env = {
    enable = lib.mkEnableOption "enable nixos base environment configurations" // { default = true; };
    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [
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
      description = "List of packages to install as system packages";
    };
    fonts = {
      enable = lib.mkEnableOption "enable font configuration and download" // { default = true; };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = with pkgs; [
          # icon fonts
          material-design-icons
          font-awesome

          # nerdfonts
          nerd-fonts.symbols-only
          nerd-fonts.fira-code
          nerd-fonts.jetbrains-mono
          nerd-fonts.hack
          nerd-fonts.space-mono
        ];
        description = "list of font packages to install";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = cfg.packages;
    };

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
  };
}

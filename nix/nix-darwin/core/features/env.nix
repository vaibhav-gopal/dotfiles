{ config, pkgs, lib, pkgs-unstable, ... }:
let
  cfg = config.darwin.env;
in {
  options.darwin.env = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable darwin base environment configurations";
    };
    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [
        # install stable packages ; static, small changes between versions, need stability
        pkgs.wget
        pkgs.vim
        pkgs.git
        # install unstable packages ; need the latest version (bug fixes or etc...)
      ];
      description = "List of packages to install as system packages";
    };
    fonts = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enable font configuration and download";
      };
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

    # Create /etc/zshrc that loads the nix-darwin environment
    programs.zsh.enable = true;
    environment.shells = [
      pkgs.zsh
    ];

    # Fonts
    fonts = lib.mkIf cfg.fonts.enable {
      packages = cfg.fonts.packages;
    };
  };
}
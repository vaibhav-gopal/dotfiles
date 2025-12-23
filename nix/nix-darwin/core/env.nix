{ config, pkgs, lib, pkgs-unstable, usrlib, ... }:
let
  cfg = config.core.env;
in {
  options.core.env = {
    enable = usrlib.mkEnableOptionTrue "enable darwin base environment configurations";
    packages = usrlib.mkListOfPackagesOption "List of packages to install as system packages" [
      # install stable packages ; static, small changes between versions, need stability
      pkgs.wget
      pkgs.vim
      pkgs.git
      # install unstable packages ; need the latest version (bug fixes or etc...)
      pkgs-unstable.just
      pkgs-unstable.nixd
      pkgs-unstable.nil
    ];
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

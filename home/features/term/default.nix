{ config, lib, pkgs, usrlib, ... }:

let 
  cfg = config.features.term;
in {
  options.features.term = {
    enable = usrlib.mkEnableOptionTrue "Enable some terminal utilities";
    zellij = {
      enable = usrlib.mkEnableOptionTrue "Enable zellij the terminal multiplexer";
      enable_config = usrlib.mkEnableOptionTrue "Enable zellij config setup";
      package = usrlib.mkPackageOption "Default zellij package to use" pkgs.zellij;
      auto_start = usrlib.mkEnableOptionTrue "Enable zellij auto-start on shell start (shell-integration recommended)";
    };
    yazi = {
      enable = usrlib.mkEnableOptionTrue "Enable yazi the terminal file explorer";
      enable_config = usrlib.mkEnableOptionTrue "Enable yazi config setup";
      package = usrlib.mkPackageOption "Default yazi package to use" pkgs.yazi;
    };
    starship = {
      enable = usrlib.mkEnableOptionTrue "Enable starship the terminal prompt";
      enable_config = usrlib.mkEnableOptionTrue "Enable starship config setup";
      package = usrlib.mkPackageOption "Default starship package to use" pkgs.starship;
    };
    kitty = {
      enable = usrlib.mkEnableOptionTrue "Enable kitty terminal emulator";
      enable_config = usrlib.mkEnableOptionTrue "Enable kitty config setup";
      package = usrlib.mkPackageOption "Default kitty package to use" pkgs.kitty;
    };
  };

  config = lib.mkIf cfg.enable {
    # zellij : terminal multiplexer
    programs.zellij = lib.mkIf cfg.zellij.enable {
      enable = true;
      package = cfg.zellij.package;
      attachExistingSession = false; # attach existing session when auto-start'ing zellij
      exitShellOnExit = false; # exit shell when exiting an auto-start'ed zellij session
    };
    xdg.configFile."zellij".source = lib.mkIf cfg.zellij.enable_config (
      config.lib.file.mkOutOfStoreSymlink "${config.extPaths.commonFeaturesDir}/term/zellij.d"
    );
    features.shell.zsh.zshrc = lib.mkIf cfg.zellij.auto_start ''
      eval "$(zellij setup --generate-auto-start zsh)"
    '';
    features.shell.bash.bashrc = lib.mkIf cfg.zellij.auto_start ''
      eval "$(zellij setup --generate-auto-start zsh)"
    '';

    # yazi : terminal file manager and viewer (enables lots of features, batch rename, archiving, trash bin, etc...)
    programs.yazi = lib.mkIf cfg.yazi.enable {
      enable = true;
      package = cfg.yazi.package;
      shellWrapperName = "y";
    };
    xdg.configFile."yazi".source = lib.mkIf cfg.starship.enable_config (
      config.lib.file.mkOutOfStoreSymlink "${config.extPaths.commonFeaturesDir}/term/yazi.d"
    );

    # starship : terminal prompt
    programs.starship = lib.mkIf cfg.starship.enable {
      enable = true;
    };
    xdg.configFile."starship.toml".source = lib.mkIf cfg.starship.enable_config (
      config.lib.file.mkOutOfStoreSymlink "${config.extPaths.commonFeaturesDir}/term/starship.d/starship.toml"
    );

    # kitty : terminal emulator
    programs.kitty = lib.mkIf cfg.kitty.enable {
      enable = true;
      package = cfg.kitty.package;
      extraConfig = ''
        include ./kitty_custom.conf
        shell ${pkgs.zsh}/bin/zsh
      '';
    };
    xdg.configFile."kitty/kitty_custom.conf".source = lib.mkIf cfg.kitty.enable_config (
      config.lib.file.mkOutOfStoreSymlink "${config.extPaths.commonFeaturesDir}/term/kitty.d/kitty.conf"
    );
    
    # Home shell aliases
    home.shellAliases = {
      z = lib.mkIf cfg.zellij.enable "zellij";
    };
  };
}

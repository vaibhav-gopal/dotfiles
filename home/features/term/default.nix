{ config, lib, pkgs, ... }:

let 
  cfg = config.features.term;
in {
  options.features.term = {
    enable = lib.mkEnableOption "Enable some terminal utilities" // { default = true; };
    zellij = {
      enable = lib.mkEnableOption "Enable zellij the terminal multiplexer" // { default = true; };
      enable_config = lib.mkEnableOption "Enable zellij config setup" // { default = true; };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.zellij;
        defaultText = lib.literalExpression "pkgs.zellij";
        description = "Default zellij package to use";
      };
    };
    yazi = {
      enable = lib.mkEnableOption "Enable yazi the terminal file explorer" // { default = true; };
      enable_config = lib.mkEnableOption "Enable yazi config setup" // { default = true; };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.yazi;
        defaultText = lib.literalExpression "pkgs.yazi";
        description = "Default yazi package to use";
      };
    };
    starship = {
      enable = lib.mkEnableOption "Enable starship the terminal prompt" // { default = true; };
      enable_config = lib.mkEnableOption "Enable starship config setup" // { default = true; };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.starship;
        defaultText = lib.literalExpression "pkgs.starship";
        description = "Default starship package to use";
      };
    };
    ghostty = {
      enable = lib.mkEnableOption "Enable ghostty the terminal emulator" // { default = true; };
      enable_config = lib.mkEnableOption "Enable ghostty config setup" // { default = true; };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.ghostty;
        defaultText = lib.literalExpression "pkgs.ghostty";
        description = "Default ghostty package to use";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # zellij : terminal multiplexer
    programs.zellij = lib.mkIf cfg.zellij.enable {
      enable = true;
      package = cfg.zellij.package;
    };
    xdg.configFile."zellij".source = lib.mkIf cfg.zellij.enable_config (
      config.lib.file.mkOutOfStoreSymlink "${config.extPaths.commonFeaturesDir}/term/zellij.d"
    );

    # yazi : terminal file manager and viewer (enables lots of features, batch rename, archiving, trash bin, etc...)
    programs.yazi = lib.mkIf cfg.yazi.enable {
      enable = true;
      package = cfg.yazi.package;
      shellWrapperName = "yy"; # shell alias : DO NOT CHANGE (breaks automatic cd)
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

    # ghostty : terminal emulator
    programs.ghostty = lib.mkIf cfg.ghostty.enable {
      enable = true;
    };
    xdg.configFile."ghostty/config".source = lib.mkIf cfg.ghostty.enable_config (
      config.lib.file.mkOutOfStoreSymlink "${config.extPaths.commonFeaturesDir}/term/ghostty.d/ghostty.config"
    );
    
    # Home shell aliases
    home.shellAliases = {
      zj = lib.mkIf cfg.zellij.enable "zellij";
    };
  };
}

{ config, lib, pkgs, pkgs-unstable, ... }:

let 
  cfg = config.features.term;
in {
  options.features.term = {
    enable = lib.mkEnableOption "Enable some terminal utilities";
    zellij = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable zellij the terminal multiplexer";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs-unstable.zellij;
        defaultText = lib.literalExpression "pkgs.zellij";
        description = "Default zellij package to use";
      };
    };
    yazi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable yazi the terminal file explorer";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs-unstable.yazi;
        defaultText = lib.literalExpression "pkgs.yazi";
        description = "Default yazi package to use";
      };
    };
    starship = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable starship the terminal prompt";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.starship;
        defaultText = lib.literalExpression "pkgs.starship";
        description = "Default starship package to use";
      };
    };
    ghostty = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable ghostty the terminal emulator ; still have to download yourself (package is broken currently)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # zellij : terminal multiplexer
    programs.zellij = lib.mkIf cfg.zellij.enable {
      enable = true;
      package = cfg.zellij.package;
    };
    # Symlink external Zellij config
    xdg.configFile."zellij".source = 
      lib.mkIf cfg.zellij.enable
      (config.lib.file.mkOutOfStoreSymlink "./zellij.d");

    # yazi : terminal file manager and viewer (enables lots of features, batch rename, archiving, trash bin, etc...)
    programs.yazi = lib.mkIf cfg.yazi.enable {
      enable = true;
      package = cfg.yazi.package;
      shellWrapperName = "yy"; # shell alias : DO NOT CHANGE (breaks automatic cd)
    };
    # symlink external config files
    xdg.configFile."yazi".source = 
      lib.mkIf cfg.starship.enable
      (config.lib.file.mkOutOfStoreSymlink "./yazi.d");

    # starship : terminal prompt
    programs.starship = lib.mkIf cfg.starship.enable {
      enable = true;
    };
    # symlink external config file
    xdg.configFile."starship.toml".source = 
      lib.mkIf cfg.starship.enable
      (config.lib.file.mkOutOfStoreSymlink "./term.d/starship.toml");

    # ghostty : terminal emulator (install manually ;nix program and package is broken)
    xdg.configFile."ghostty/config".source = 
      lib.mkIf cfg.ghostty.enable
      (config.lib.file.mkOutOfStoreSymlink "./term.d/ghostty.config");
    
    # Home shell aliases
    home.shellAliases = {
      zj = lib.mkIf cfg.zellij.enable "zellij";
      yz = lib.mkIf cfg.yazi.enable "yazi";
    };
  };
}
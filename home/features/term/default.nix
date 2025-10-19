{ config, lib, pkgs, ... }:

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
        default = pkgs.zellij;
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
        default = pkgs.yazi;
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
    xdg.configFile."zellij/config.kdl".source = 
      lib.mkIf cfg.zellij.enable
      (config.lib.file.mkOutOfStoreSymlink ./term.d/zellij.kdl);

    # yazi : terminal file manager and viewer (enables lots of features, batch rename, archiving, trash bin, etc...)
    programs.yazi = lib.mkIf cfg.yazi.enable {
      enable = true;
      package = cfg.yazi.package;
      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
        };
      };
    };

    # starship : terminal prompt
    programs.starship = lib.mkIf cfg.starship.enable {
      enable = true;
    };
    # symlink external config file
    xdg.configFile."starship.toml".source = 
      lib.mkIf cfg.starship.enable
      (config.lib.file.mkOutOfStoreSymlink ./term.d/starship.toml);

    # ghostty : terminal emulator (install manually ;nix program and package is broken)
    xdg.configFile."ghostty/config".source = 
      lib.mkIf cfg.ghostty.enable
      (config.lib.file.mkOutOfStoreSymlink ./term.d/ghostty.config);
    
    # Home shell aliases
    home.shellAliases = {
      zj = lib.mkIf cfg.zellij.enable "zellij";
    };
  };
}
{ config, lib, pkgs, ... }:

let 
  cfg = config.features.vim;
in {
  options.features.vim = {
    enable = lib.mkEnableOption "Enable vim feature";
    nvim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable nvim package and feature";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.neovim-unwrapped;
        defaultText = lib.literalExpression "pkgs.neovim-unwrapped";
        description = "The neovim package to use (Uses unwrapped by default in programs)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vim = {
      enable = true;
      defaultEditor = true;
    };
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "./nvim.d";
      
    programs.neovim = {
      enable = cfg.nvim.enable;
      package = cfg.nvim.package;
    };
    home.file."${config.home.homeDirectory}/.vimrc".source =
      lib.mkIf cfg.nvim.enable
      (config.lib.file.mkOutOfStoreSymlink "./vim.d/vimrc");
  };
}
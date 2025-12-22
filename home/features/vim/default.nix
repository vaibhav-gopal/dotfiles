{ config, lib, pkgs, ... }:

let 
  cfg = config.features.vim;
in {
  options.features.vim = {
    enable = lib.mkEnableOption "Enable vim feature" // { default = true; };
    nvim = {
      enable = lib.mkEnableOption "Enable nvim package and feature" // { default = true; };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.neovim-unwrapped;
        defaultText = lib.literalExpression "pkgs.neovim-unwrapped";
        description = "The neovim package to use (Uses unwrapped by default in programs)";
      };
    };
    vscode = {
      enable = lib.mkEnableOption "Enable vscode vimrc file setup" // { default = true; };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vim = {
      enable = true;
    };
    programs.neovim = {
      enable = cfg.nvim.enable;
      package = cfg.nvim.package;
    };

    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.extPaths.commonFeaturesDir}/vim/nvim.d";
    home.file."${config.home.homeDirectory}/.vimrc".source =
      lib.mkIf cfg.nvim.enable
      (config.lib.file.mkOutOfStoreSymlink "${config.extPaths.commonFeaturesDir}/vim/vim.d/vimrc");
    home.file."${config.home.homeDirectory}/.vscodevimrc".source = 
      lib.mkIf cfg.vscode.enable
      (config.lib.file.mkOutOfStoreSymlink "${config.extPaths.commonFeaturesDir}/vim/vscode.d/vimrc");

    home.sessionVariables = {
      EDTIOR = lib.mkDefault "vim";
      VISUAL = lib.mkDefault "vim";
    };
  };
}

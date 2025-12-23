{ config, lib, pkgs, usrlib, ... }:

let 
  cfg = config.features.vim;
in {
  options.features.vim = {
    enable = usrlib.mkEnableOptionTrue "Enable vim feature";
    nvim = {
      enable = usrlib.mkEnableOptionTrue "Enable nvim package and feature";
      package = usrlib.mkPackageOption "The neovim package to use (Uses unwrapped by default in programs)" pkgs.neovim-unwrapped;
    };
    vscode = {
      enable = usrlib.mkEnableOptionTrue "Enable vscode vimrc file setup";
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

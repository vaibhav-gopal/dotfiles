{ config, hmPaths, ... }:

{
  programs.vim = {
    enable = true;
  };
  programs.neovim = {
    enable = true;
  };

  xdg.configFile."nvim".source = 
    config.lib.file.mkOutOfStoreSymlink (hmPaths.homeCommonConfigsDir + "/nvim.d");
  home.file."${config.home.homeDirectory}/.vimrc".source = 
    config.lib.file.mkOutOfStoreSymlink (hmPaths.homeCommonConfigsDir + "/vim.d/vimrc");
}


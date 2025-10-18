{ config, ... }:

{
  programs.vim = {
    enable = true;
  };
  programs.neovim = {
    enable = true;
  };

  xdg.configFile."nvim".source = 
    config.lib.file.mkOutOfStoreSymlink (config.paths.commonConfigsDir + "/nvim.d");
  home.file."${config.home.homeDirectory}/.vimrc".source = 
    config.lib.file.mkOutOfStoreSymlink (config.paths.commonConfigsDir + "/vim.d/vimrc");
}


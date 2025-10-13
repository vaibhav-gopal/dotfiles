{ config, hmPaths, ... }:

{
  programs.vim = {
    enable = true;
  };
  programs.neovim = {
    enable = true;
  };

  home.file."${config.home.homeDirectory}/.config/nvim/init.lua".source = hmPaths.homeCmmonConfigsDir + "/vim.d/init.lua";
  home.file."${config.home.homeDirectory}/.config/nvim/init.vim".source = hmPaths.homeCommonConfigsDir + "/vim.d/init.vim";
  home.file."${config.home.homeDirectory}/.vimrc".source = hmPaths.homeCommonConfigsDir + "/vim.d/vimrc";
}


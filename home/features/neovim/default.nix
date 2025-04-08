{ config, pkgs, hmPaths, ... }:

{
  programs.neovim = {
    enable = true;
  };

  home.file."${config.home.homeDirectory}/.config/nvim/init.lua".source = hmPaths.homeCommonConfigsDir + "/vim.d/init.lua";
  home.file."${config.home.homeDirectory}/.config/nvim/init.vim".source =hmPaths.homeCommonConfigsDir + "/vim.d/init.vim";

}


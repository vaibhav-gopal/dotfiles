{ config, pkgs, hmPaths, ... }:

{
  programs.vim = {
    enable = true;
  };

  home.file."${config.home.homeDirectory}/.vimrc".source = hmPaths.homeCommonConfigsDir + "/vim.d/vimrc";
}


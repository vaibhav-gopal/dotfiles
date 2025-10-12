{ config, pkgs, hmPaths, ... }:

{
  programs.neovim = {
    enable = true;
  };

  home.file."${config.home.homeDirectory}/.config/nvim/init.lua".source = hmPaths.homeFeaturesDir + "/neovim/nvim.d/init.lua";
  home.file."${config.home.homeDirectory}/.config/nvim/init.vim".source = hmPaths.homeFeaturesDir + "/neovim/nvim.d/init.vim";

}


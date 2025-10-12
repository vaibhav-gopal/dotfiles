{ config, pkgs, hmPaths, ... }:

{
  # zellij : terminal multiplexer
  programs.zellij.enable = true;
  # Symlink external Zellij config
  home.file."${config.home.homeDirectory}/.config/zellij/config.kdl".source = hmPaths.homeCommonConfigsDir + "/term.d/zellij.kdl";

  # yazi : terminal file manager and viewer (enables lots of features, batch rename, archiving, trash bin, etc...)
  programs.yazi.enable = true;
  programs.yazi.settings = {
    manager = {
      show_hidden = true;
      sort_dir_first = true;
    };
  };

  home.shellAliases = {
    zj = "zellij";
  };
}

{ config, pkgs, hmPaths, ... }:

{
  programs.zellij = {
    enable = true;
  };

  # Symlink external Zellij config
  home.file."${config.home.homeDirectory}/.config/zellij/config.kdl".source = hmPaths.homeCommonConfigsDir + "/term.d/zellij.kdl";

  home.shellAliases = {
    zj = "zellij";
  };
}

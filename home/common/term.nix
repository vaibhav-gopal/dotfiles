{ config, pkgs, hmPaths, ... }:

{
  # zellij : terminal multiplexer
  programs.zellij.enable = true;

  # ghostty : terminal emulator of choice
  programs.ghostty.enable = true;
  # see https://ghostty.org/docs/config/reference for more info
  programs.ghostty.settings = {
    background-opacity = 0.75;
    background-blur = 20;
  };

  # Symlink external Zellij config
  home.file."${config.home.homeDirectory}/.config/zellij/config.kdl".source = hmPaths.homeCommonConfigsDir + "/term.d/zellij.kdl";

  home.shellAliases = {
    zj = "zellij";
  };
}

{ config, lib, ... }:

{
  # zellij : terminal multiplexer
  programs.zellij.enable = true;
  # Symlink external Zellij config
  xdg.configFile."zellij/config.kdl".source = 
    lib.file.mkOutOfStoreSymlink (config.paths.commonConfigsDir + "/term.d/zellij.kdl");

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

  programs.starship = {
    enable = true;
  };
  
  xdg.configFile."starship.toml".source = 
    lib.file.mkOutOfStoreSymlink (config.paths.commonConfigsDir + "/term.d/starship.toml");

  # setting up terminal themes/settings for different terminal emulators via home.file
  # ghostty ; install manually (nix program and package is broken)
  xdg.configFile."ghostty/config".source = 
    lib.file.mkOutOfStoreSymlink (config.paths.commonConfigsDir + "/term.d/ghostty.config");
}

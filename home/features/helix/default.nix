{ config, pkgs, lib, modeConfig, hmPaths, ... }:

{
  programs.helix = {
    enable = true;

    # Optional: override default config directory if you want full control
    # settings = { theme = "gruvbox"; };
    # languages = { language-server = ... };
  };
}

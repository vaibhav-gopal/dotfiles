{ config, pkgs, ... }:

{
  home.packages = [ pkgs.glow ];

  home.shellAliases = {
    mdp = "glow";
  };
}

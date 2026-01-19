{ config, lib, pkgs, usrlib, ... }:

let 
  cfg = config.features.bun;
in {
  options.features.bun = {
    enable = usrlib.mkEnableOptionTrue "Enable the bun program.";
    package = usrlib.mkPackageOption "The bun package to use" pkgs.bun;
    settings = usrlib.mkAttrsOption "Extra toml settings for $XDG_CONFIG_HOME/.bunfig.toml\nAll in TOML via nix attribute sets" {};
  };

  config = lib.mkIf cfg.enable {
    programs.bun.enable = true;
    programs.bun.package = cfg.package;
    programs.bun.settings = cfg.settings;
  };
}

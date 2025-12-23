{ config, lib, pkgs, usrlib, ... }:

let 
  cfg = config.features.uv;
in {
  options.features.uv = {
    enable = usrlib.mkEnableOptionTrue "Enable uv : python env manager";
    package = usrlib.mkPackageOption "The uv package to use" pkgs.uv;
    settings = usrlib.mkAttrsOption "Extra toml settings for $XDG_CONFIG_HOME/uv/uv.toml\nAll in TOML via nix attribute sets\nSee https://docs.astral.sh/uv/configuration/files/ and https://docs.astral.sh/uv/reference/settings/ for more information." {};
  };

  config = lib.mkIf cfg.enable {
    programs.uv.enable = true;
    programs.uv.package = cfg.package;
    programs.uv.settings = cfg.settings;
  };
}
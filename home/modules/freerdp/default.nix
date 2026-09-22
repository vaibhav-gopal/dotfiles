{ config, lib, pkgs, usrlib, ... }:
let
  cfg = config.common.freerdp;
in {
  # MODULE OPTIONS DECLARATION
  options.common.freerdp = {
    enable = usrlib.mkEnableOptionFalse "Enable the FreeRDP remote desktop client. The package has no `freerdp` binary: `sdl-freerdp` is the native-window client, `xfreerdp` needs an X server (XQuartz on macOS).";
    package = usrlib.mkPackageOption "The freerdp package to use" pkgs.freerdp;
    alias = usrlib.mkStringOption "Shell alias pointing at `sdl-freerdp` (empty disables alias)" "freerdp";
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.shellAliases = lib.mkIf (cfg.alias != "") {
      ${cfg.alias} = "sdl-freerdp";
    };
  };
}

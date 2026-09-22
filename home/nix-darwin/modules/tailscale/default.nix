# Tailscale CLI alias for the `tailscale-app` cask.
#
# The cask ships the CLI inside the app bundle rather than on PATH, so this
# exposes it the way Tailscale's own macOS docs suggest. The cask itself is
# declared in the system module (nix/nix-darwin/<host>).
{ config, lib, usrlib, ... }:

let
  cfg = config.nixtype.tailscale;
in {
  options.nixtype.tailscale = {
    enable = usrlib.mkEnableOptionFalse "Enable the tailscale CLI alias for the tailscale-app cask";
    appPath = usrlib.mkStringOption "Path to the installed Tailscale.app bundle" "/Applications/Tailscale.app";
    alias = usrlib.mkStringOption "Shell alias for the bundled CLI (empty disables alias)" "tailscale";
  };

  config = lib.mkIf (cfg.enable && cfg.alias != "") {
    home.shellAliases = {
      ${cfg.alias} = "\"${cfg.appPath}/Contents/MacOS/Tailscale\"";
    };
  };
}

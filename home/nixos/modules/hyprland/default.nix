{ config, lib, usrlib, pkgs, ... }:
let
  cfg = config.nixtype.hyprland;
in {
  # MODULE OPTIONS DECLARATION
  options.nixtype.hyprland = {
    enable = usrlib.mkEnableOptionTrue "Enable Hyprland Wayland compositor";
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false; # conflicts with UWSM (which is preferred) (UWSM = universal wayland session manager ; systemd-based tool wraps compositors in systemd units for session handling/setup)
      # set the Hyperland and XDPH packages to null to use the ones from the NixOS module (XDPH = xdg-desktop-portal-hyprland ; XDP = interface for apps to access desktop stuff like notifications, file pickers, etc...)
      package = null;
      portalPackage = null;

      # If not using UWSM
      # wayland.windowManager.hyprland.systemd.variables = ["--all"];

      plugins = [
        # pkgs.hyprlandPlugins.<PLUGIN_NAME>
      ];
    };

    # 
    xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh"; 
  };
}
{ config, lib, usrlib, pkgs, ... }:
let
  cfg = config.system.features.hyprland;
in {
  # MODULE OPTIONS DECLARATION
  options.system.features.hyprland = {
    enable = usrlib.mkEnableOptionTrue "Enable Hyprland Wayland compositor";
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    programs.kitty.enable = true; # recommended terminal emulator for hyprland (for some reason)
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false; # conflicts with UWSM (which is preferred)
      # set the Hyperland and XDPH packages to null to use the ones from the NixOS module
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
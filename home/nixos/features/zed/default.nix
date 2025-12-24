{ config, lib, pkgs-unstable, usrlib, ... }:
let
  cfg = config.system.features.zed;
in {
  options.system.features.zed = {
    enable = usrlib.mkEnableOptionTrue "Enable zed editor application";
    package = usrlib.mkPackageOption "The zed editor package to use" pkgs-unstable.zed-editor;
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      package = cfg.package;
      extensions = ["nix" "toml" "dockerfile"];
      userSettings = {
        theme = {
          mode = "system";
          dark = "One Dark";
          light = "One Light";
        };
        hour_format = "hour24";
        vim_mode = true;
      };
    };
  };
}
{ config, lib, usrlib, ... }:

let
  cfg = config.modules.statusbar;
in {
  options.modules.statusbar = {
    # NOTE: please see the setup prereqs here first: https://felixkratz.github.io/SketchyBar/setup
    enable = usrlib.mkEnableOptionFalse "enable status bar customization via sketchybar";
    # config options are here: https://felixkratz.github.io/SketchyBar/config/bar
    config = usrlib.mkLinesOption "The sketchybar config, default is bash not lua" ''
        # Define colors
        export COLOR_BLACK="0xff181926"
        export COLOR_WHITE="0xffcad3f5"

        # Configure bar
        sketchybar --bar height=32 \
                        position=top \
                        padding_left=10 \
                        padding_right=10 \
                        color=$COLOR_BLACK

        # Configure default values
        sketchybar --default icon.font="SF Pro:Bold:14.0" \
                            icon.color=$COLOR_WHITE \
                            label.font="SF Pro:Bold:14.0" \
                            label.color=$COLOR_WHITE

        # Add items to the bar
        sketchybar --add item clock right \
                  --set clock script="date '+%H:%M'" \
                              update_freq=10

        # Update the bar
        sketchybar --update
      '';
  };

  config.services.sketchybar = lib.mkIf cfg.enable {
    enable = true;
    config = cfg.config;
  };
}

{ config, lib, ... }:

let
  cfg = config.darwin.keyboard;
in {
  options.darwin.keyboard = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable remapping keyboard";
    };

    userKeyMapping = lib.mkOption {
      type = lib.types.listOf (lib.types.attrsOf lib.types.int);
      # see https://developer.apple.com/library/archive/technotes/tn2450/_index.html
      default = let
        cpslck =  30064771129;
        lshift =  30064771297;
        lctrl =   30064771296;
        lopt =    30064771298;
        ropt =    30064771302;
        rctrl =   30064771300;
        rcmd =    30064771303;
        f13 =     30064771176;
        esc =     30064771113;
      in [
        {
          HIDKeyboardModifierMappingSrc = cpslck; # pretty useful, replacing caps lock to left shift (for both shortcuts and typing)
          HIDKeyboardModifierMappingDst = lshift;
        }
        {
          HIDKeyboardModifierMappingSrc = lshift; # map left shift to esc (for vim)
          HIDKeyboardModifierMappingDst = esc;
        }
        {
          HIDKeyboardModifierMappingSrc = rcmd; # replace right command with right option
          HIDKeyboardModifierMappingDst = ropt;
        }
        {
          HIDKeyboardModifierMappingSrc = ropt; # replace right option with right control
          HIDKeyboardModifierMappingDst = rctrl;
        }
      ];
    };
  };

  config.system.activationScripts.keyboard.text = lib.mkIf cfg.enable (''
      # Configuring keyboard
      echo "remapping keys..." >&2
      hidutil property --set '{"UserKeyMapping":${builtins.toJSON cfg.userKeyMapping}}'
    '');

  config.environment.userLaunchAgents.keyboardRemapping = lib.mkIf cfg.enable {
    enable = true;
    text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>com.nix-darwin.keyboardRemapper</string>
        <key>ProgramArguments</key>
        <array>
            <string>hidutil property --set '{"UserKeyMapping":${builtins.toJSON cfg.userKeyMapping}}'</string>
        </array>
        <key>KeepAlive</key>
        <true/>
    </dict>
    </plist>
    '';
  };
}
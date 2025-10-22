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
      # caps lock : 30064771129
      # left control : 30064771296
      # left option : 30064771298
      # F13 : 3006477117
      default = [
        {
          HIDKeyboardModifierMappingSrc = 30064771129; # caps lock into
          HIDKeyboardModifierMappingDst = 30064771298; # left option
        }
        {
          HIDKeyboardModifierMappingSrc = 30064771298; # left option into
          HIDKeyboardModifierMappingDst = 30064771296; # left control
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
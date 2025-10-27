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
        rshift =  30064771301;
        ctrl =    30064771296; # technically left control (but ignore right control since it doesn't exist on standard macbook keyboards)
        lopt =    30064771298;
        ropt =    30064771302;
        lcmd =    30064771299;
        rcmd =    30064771303;
        f13 =     30064771176;
        f14 =     30064771177;
        esc =     30064771113;
        appbtn =  30064771173; # "Keyboard Application" key ; equivalent to right click, can then navigate by spelling out the menu item
      in [
        # RULES
        # no duplicate keys (keyboards already small and restrictive...)

        # BUILT-INS
        # fn key + delete (backspace) = delete (forward ; classic)
        # fn key + enter = keypad enter / insert
        # fn key + arrow keys = PgUp/PgDown and Home/End

        # SHIFT AND CAPS LOCK REASSIGNMENT (RESULT : caps lock and right shift unbound, f13/f14 added (can bind to user shortcuts without worrying about conflicts))
        {
          HIDKeyboardModifierMappingSrc = cpslck; # caps lock -> left shift (way easier typing and ergonomics)
          HIDKeyboardModifierMappingDst = lshift;
        }
        {
          HIDKeyboardModifierMappingSrc = lshift; # left shift -> esc (for vim and others)
          HIDKeyboardModifierMappingDst = esc;
        }
        {
          HIDKeyboardModifierMappingSrc = esc; # esc -> f13 (custom non-colliding user shortcuts)
          HIDKeyboardModifierMappingDst = f13;
        }
        {
          HIDKeyboardModifierMappingSrc = rshift; # right shift -> f14 (custom non-colliding user shortcuts)
          HIDKeyboardModifierMappingDst = f14;
        }
        # MODIFIER REASSIGNMENT (RESULT : right command unbound, right click added)
        {
          HIDKeyboardModifierMappingSrc = rcmd; # right cmd -> control (for shortcuts, and easy right-click with trackpad)
          HIDKeyboardModifierMappingDst = ctrl;
        }
        {
          HIDKeyboardModifierMappingSrc = ctrl; # control -> right click (menu btn / app btn)
          HIDKeyboardModifierMappingDst = appbtn;
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
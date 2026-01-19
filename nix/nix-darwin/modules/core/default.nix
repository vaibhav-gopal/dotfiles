{ lib, username, homedirectory, hostname, ... }:
{
  imports = [
    ./env.nix
    ./home.nix
    ./keyboard.nix
  ];

  # Set home directory and primary user
  system.primaryUser = username;
  users.users.${username}.home = homedirectory;
  networking.computerName = hostname;
  networking.hostName = hostname;
  networking.localHostName = hostname;

  # TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    stateVersion = 6;

    defaults = {
      # dock settings
      dock = {
        autohide = true;
        show-recents = false;

        # hot corners
        wvous-tl-corner = 13;  # top-left - Lock Screen
        wvous-tr-corner = 2;  # top-right - Mission Control
        wvous-bl-corner = 4;  # bottom-left - Desktop
        wvous-br-corner = 3;  # bottom-right - Application Windows
      };

      # finder settings
      finder = {
        _FXShowPosixPathInTitle = true;  # show full path in finder title
        _FXSortFoldersFirst = true; # sort folders first
        FXDefaultSearchScope = null; # default search scope is "This Mac" (null)
        AppleShowAllExtensions = true;  # show all file extensions
        AppleShowAllFiles = true; # show hidden files
        FXEnableExtensionChangeWarning = false;  # disable warning when changing file extension
        QuitMenuItem = true;  # enable quit menu item
        ShowPathbar = true;  # show path bar
        ShowStatusBar = true;  # show status bar
      };

      # trackpad settings
      trackpad = {
        Clicking = true; # enable tap to click
        TrackpadRightClick = true; # enable right click
        TrackpadThreeFingerDrag = false; # enables selecting text with three finger drag
      };

      # customize settings that not supported by nix-darwin directly
      # Incomplete list of macOS `defaults` commands :
      #   https://github.com/yannbertrand/macos-defaults
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";  # dark mode
        ApplePressAndHoldEnabled = false;  # disable press and hold (the accent selector)
        InitialKeyRepeat = 15;  # default is 15
        KeyRepeat = 3;  # default is 2
        NSAutomaticCapitalizationEnabled = false;  # disable auto capitalization
        NSAutomaticDashSubstitutionEnabled = false;  # disable auto dash substitution
        NSAutomaticPeriodSubstitutionEnabled = false;  # disable auto period substitution
        NSAutomaticQuoteSubstitutionEnabled = false;  # disable auto quote substitution
        NSAutomaticSpellingCorrectionEnabled = false;  # disable auto spelling correction
        NSWindowShouldDragOnGesture = true; # enables moving windows by dragging on them anywhere with command + control held down
      };

      # Customize settings that not supported by nix-darwin directly
      # see the source code of this project to get more undocumented options:
      #    https://github.com/rgcr/m-cli
      # 
      # All custom entries can be found by running `defaults read` command.
      # or `defaults read xxx` to read a specific domain.
      CustomUserPreferences = {
      };

      loginwindow = {
        GuestEnabled = false;  # disable guest user
      };
    };

    # keyboard settings : see features/keyboard.nix for more customizable alternative, leave this disabled!)
    keyboard = {
      enableKeyMapping = false;  # enable key mapping so that we can remap caps lock to escape
      # NOTE: do NOT support remap capslock to both control and escape at the same time
      # remapCapsLockToControl = true;  # remap caps lock to control, slightly more useful than just esc
      # remapCapsLockToEscape  = true;   # remap caps lock to escape, useful for vim
    };
  };
}

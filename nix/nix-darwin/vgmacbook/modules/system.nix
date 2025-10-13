{ pkgs, username, homedirectory, ... }:
{
  # Set home directory and primary user
  system.primaryUser = username;
  users.users.${username}.home = homedirectory;

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
        wvous-tr-corner = 3;  # top-right - Application Windows
        wvous-bl-corner = 2;  # bottom-left - Mission Control
        wvous-br-corner = 4;  # bottom-right - Desktop
      };

      # finder settings
      finder = {
        _FXShowPosixPathInTitle = true;  # show full path in finder title
        AppleShowAllExtensions = true;  # show all file extensions
        FXEnableExtensionChangeWarning = false;  # disable warning when changing file extension
        QuitMenuItem = true;  # enable quit menu item
        ShowPathbar = true;  # show path bar
        ShowStatusBar = true;  # show status bar
      };

      # trackpad settings
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };

      # customize settings that not supported by nix-darwin directly
      # Incomplete list of macOS `defaults` commands :
      #   https://github.com/yannbertrand/macos-defaults
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";  # dark mode
        ApplePressAndHoldEnabled = true;  # enable press and hold
        InitialKeyRepeat = 15;  # default is 15
        KeyRepeat = 3;  # default is 2
        NSAutomaticCapitalizationEnabled = false;  # disable auto capitalization
        NSAutomaticDashSubstitutionEnabled = false;  # disable auto dash substitution
        NSAutomaticPeriodSubstitutionEnabled = false;  # disable auto period substitution
        NSAutomaticQuoteSubstitutionEnabled = false;  # disable auto quote substitution
        NSAutomaticSpellingCorrectionEnabled = false;  # disable auto spelling correction
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

    # keyboard settings
    keyboard = {
      enableKeyMapping = true;  # enable key mapping so that we can use `option` as `control`

      # NOTE: do NOT support remap capslock to both control and escape at the same time
      remapCapsLockToControl = false;  # remap caps lock to control, useful for emac users
      remapCapsLockToEscape  = true;   # remap caps lock to escape, useful for vim users
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      # nerdfonts
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.space-mono
    ];
  };
}
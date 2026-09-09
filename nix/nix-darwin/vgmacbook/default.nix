{ ... }:
{
  imports = [
  ];

  # Homebrew: macOS GUI apps + Mac App Store apps.
  # CLI tooling belongs in home-manager - see LEARN.md section 8.
  #
  # NOTE: `modules.homebrew.cleanup` is "zap", so anything Homebrew installed
  #       that is NOT listed here is removed on the next rebuild. Manually
  #       installed apps are invisible to brew and are left alone.
  #
  # FIRST RUN: most of the casks below are already installed by hand. Homebrew
  #            will not install a cask over an .app it did not place, so each
  #            one needs adopting ONCE before the first `just build`:
  #
  #              brew install --cask --adopt <token>
  #
  #            That takes the existing app over in place, no re-download. If a
  #            token fails on a version mismatch, either `--adopt` after
  #            updating the app, or move it to the Trash and let brew install
  #            it fresh. Once adopted, rebuilds are a no-op for that cask.
  #            See the Homebrew section of README.md.
  modules.homebrew = {
    casks = [
      # -- not previously installed, install cleanly -------------------------
      "discord"
      "libreoffice"

      # -- pkg installer, no .app conflict ----------------------------------
      "blockblock" # Objective-See; installs via pkg, not an app bundle

      # -- security ---------------------------------------------------------
      "lulu" # Objective-See firewall

      # -- browsers / terminals / editors ------------------------------------
      "firefox"
      "ghostty" # Linux-only in nixpkgs, so this must be a cask
      "visual-studio-code"
      "jetbrains-toolbox"

      # -- media / utilities -------------------------------------------------
      "spotify"
      "steam"
      "keka" # archive tool
      "ukelele" # keyboard layout editor

      # -- deliberately NOT managed -----------------------------------------
      # kitty / Zed          : installed via nix (/Applications/Nix Apps), would collide
      # affinity-{designer,photo,publisher} : casks are DEPRECATED, and the live
      #                        `affinity` cask is the different v3 unified app
      # adobe-acrobat-pro    : licensed, self-updating, painful to migrate
      # logi-options+        : driver software with system extensions
    ];

    # Mac App Store apps, by numeric ID. App-Store-exclusive software cannot be
    # a cask, so it has to go here.
    #
    # Already-installed apps need NO adoption or uninstall: `brew bundle` checks
    # the installed list and skips them. The cleanup guardrail never touches these.
    #
    # Get IDs for what is installed with: nix run nixpkgs#mas -- list
    masApps = {
      "Final Cut Pro" = 424389933;
      "Logic Pro" = 634148309;
      "GarageBand" = 682658836;
      "iMovie" = 408981434;

      # Safari extensions
      "Focus for YouTube" = 1514703160;
      "Tab Space" = 1473726602;
      "uBlock Origin Lite" = 6745342698;
      "Vimari" = 1480933944;
    };
  };
}

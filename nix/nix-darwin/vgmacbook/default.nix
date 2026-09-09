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

      # -- installer script, no .app conflict --------------------------------
      # brew runs `BlockBlock Installer -install` under sudo; the real install
      # lands in /Library/Objective-See + a LaunchDaemon, so there is no .app
      # in /Applications to collide with or to adopt. Nothing for brew to
      # verify afterwards either - see brew_adopt in nix/scripts/homebrew.sh.
      "blockblock" # Objective-See

      # -- security ---------------------------------------------------------
      "lulu" # Objective-See firewall
      "protonvpn" # no Mac App Store build exists, direct download only
      "proton-pass" # standalone desktop app; the Safari extension is in masApps

      # -- browsers / terminals / editors ------------------------------------
      "firefox"
      "ghostty" # Linux-only in nixpkgs, so this must be a cask
      "visual-studio-code"

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
      # NOTE: obtained 2026-09-09; kept here only so rebuilds keep it installed.
      # A MAS app that is NOT yet in the Apple Account library breaks activation:
      # `brew bundle` shells out to `mas install`, which only RE-downloads apps
      # already in the library, and its fallback `mas get` does not exist in the
      # mas 2.2.2 that nix-darwin puts on PATH - hence the confusing
      # "2 unexpected arguments: 'get', <id>" error. Obtain it once with:
      #   mas purchase 6502835663
      # (it prints a spurious "MASError error 5" but still downloads).
      # Unrelated to the proton-pass cask above: that app is
      # me.proton.pass.electron, this one me.proton.pass.catalyst, no collision.
      "Proton Pass for Safari" = 6502835663;
      "uBlock Origin Lite" = 6745342698;
      "Vimari" = 1480933944;
    };
  };
}

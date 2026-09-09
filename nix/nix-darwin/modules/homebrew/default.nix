# Homebrew integration.
#
# POLICY: CLI tooling belongs in nix (home-manager / environment.systemPackages).
#         Homebrew is for GUI apps (casks), Mac App Store apps, and the rare
#         formula nixpkgs does not carry or carries badly on darwin.
#
# NOTE: this module does NOT install Homebrew, it only manages its contents.
#       Install it once, manually:
#         /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#       Until then, activation prints a red "Homebrew is not installed, skipping..."
#       and carries on.
{ config, lib, pkgs, usrlib, homedirectory, ... }:
let
  cfg = config.modules.homebrew;

  # `homebrew.brewPrefix` already ends in `/bin` (e.g. `/opt/homebrew/bin`).
  brewBin = "${config.homebrew.brewPrefix}/brew";

  # launchd agents start from a bare environment, so brew and the base system
  # tools it shells out to have to be put on PATH explicitly.
  agentPath = "${config.homebrew.brewPrefix}:/usr/bin:/bin:/usr/sbin:/sbin";

  mkAgent = name: calendar: body: {
    script = ''
      export PATH="${agentPath}"
      ${body}
    '';
    serviceConfig = {
      StartCalendarInterval = calendar;
      RunAtLoad = false; # periodic maintenance, not a login task
      StandardOutPath = "${homedirectory}/Library/Logs/${name}.log";
      StandardErrorPath = "${homedirectory}/Library/Logs/${name}.log";
    };
  };

  calendarOption = desc: default: lib.mkOption {
    type = lib.types.listOf (lib.types.attrsOf lib.types.int);
    inherit default;
    description = desc;
  };
in {
  options.modules.homebrew = {
    enable = usrlib.mkEnableOptionTrue "manage Homebrew taps/formulae/casks/MAS apps declaratively";

    taps = usrlib.mkListOfStringsOption "Extra Homebrew taps to make available" [ ];
    brews = usrlib.mkListOfStringsOption "Homebrew formulae to install (prefer nix where possible)" [ ];
    casks = usrlib.mkListOfStringsOption "Homebrew casks (GUI apps) to install" [ ];
    masApps = usrlib.mkAttrsOption "Mac App Store apps to install, as { \"App Name\" = id; }" { };

    cleanup = usrlib.mkEnumOption
      "What to do with Homebrew packages that are installed but NOT declared here, on rebuild"
      "zap" [ "none" "uninstall" "zap" ];

    cleanupAgent = {
      enable = usrlib.mkEnableOptionTrue "periodic `brew cleanup` + `brew autoremove` launchd agent";
      calendar = calendarOption "When to run the cleanup agent (launchd StartCalendarInterval)"
        [{ Weekday = 0; Hour = 3; Minute = 0; }]; # Sundays, 03:00
    };

    updateAgent = {
      enable = usrlib.mkEnableOptionTrue "periodic `brew update` launchd agent (metadata only, never upgrades)";
      calendar = calendarOption "When to run the metadata update agent (launchd StartCalendarInterval)"
        [{ Hour = 9; Minute = 0; }]; # daily, 09:00
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;

      inherit (cfg) taps brews casks masApps;

      onActivation = {
        # THE guardrail: anything installed but not declared above is removed on
        # rebuild, which makes this file the single source of truth. "zap" also
        # deletes each removed cask's preferences and application support files.
        cleanup = cfg.cleanup;

        # Both false (the module defaults) so repeated `darwin-rebuild switch`
        # runs are idempotent - upgrading stays a deliberate, separate act.
        autoUpdate = false;
        upgrade = false;
      };

      global = {
        # Point HOMEBREW_BUNDLE_FILE at the Brewfile generated here, so a manual
        # `brew bundle` checks against the declared set and not a stray ~/Brewfile.
        brewfile = true;

        # Defaults to !brewfile, but be explicit: brew must not try to write a
        # lockfile next to a Brewfile that lives in the read-only nix store.
        lockfiles = false;

        # Don't let `brew install` silently refresh all metadata first.
        autoUpdate = false;
      };

      caskArgs = {
        appdir = "/Applications";
        # require_sha is deliberately NOT set: most auto-updating casks ship
        # `sha256 :no_check` and would fail outright. Apply it per-cask instead.
        # no_quarantine is deliberately NOT set: that disables Gatekeeper.
      };
    };

    # HOMEBREW_BUNDLE_FILE, HOMEBREW_NO_AUTO_UPDATE and HOMEBREW_BUNDLE_NO_LOCK
    # are set by the homebrew module itself - do not redeclare them here.
    environment.variables = {
      HOMEBREW_NO_ANALYTICS = "1";
      HOMEBREW_NO_INSECURE_REDIRECT = "1"; # refuse https -> http downgrade on fetch
      HOMEBREW_NO_ENV_HINTS = "1";
      HOMEBREW_AUTOREMOVE = "1"; # drop dependencies nothing depends on any more
      HOMEBREW_BAT = "1"; # `brew cat` through bat, which we already install
    };

    launchd.user.agents = lib.mkMerge [
      (lib.mkIf cfg.cleanupAgent.enable {
        brew-cleanup = mkAgent "brew-cleanup" cfg.cleanupAgent.calendar ''
          ${brewBin} cleanup --prune=all
          ${brewBin} autoremove
        '';
      })
      (lib.mkIf cfg.updateAgent.enable {
        # Metadata only. Never `upgrade` here - upgrades stay manual (`bup`).
        brew-update = mkAgent "brew-update" cfg.updateAgent.calendar ''
          ${brewBin} update
        '';
      })
    ];
  };
}

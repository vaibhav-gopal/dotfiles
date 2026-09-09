# Homebrew helper shell aliases.
#
# The system module (nix/nix-darwin/modules/homebrew) manages Homebrew's
# *contents*; these are just the day-to-day shortcuts, so they live with every
# other alias in home-manager. `brew` is resolved from PATH rather than
# interpolated as a store path, matching the other alias modules.
{ config, lib, usrlib, ... }:

let
  cfg = config.nixtype.homebrew;
in {
  options.nixtype.homebrew = {
    enable = usrlib.mkEnableOptionTrue "Enable the brew helper shell aliases";
  };

  config = lib.mkIf cfg.enable {
    # Homebrew Shell Aliases
    home.shellAliases = {
      bcheck = "brew bundle check --verbose";  # is the system in sync with what's declared?
      bdrift = "brew bundle cleanup";          # dry run: what is installed but NOT declared?
      bls = "brew list";                       # everything currently installed
      bout = "brew outdated --greedy";         # what is stale, incl. auto-updating casks
      bup = "brew update && brew upgrade";     # deliberate upgrade (rebuilds never upgrade)
      bclean = "brew cleanup --prune=all && brew autoremove"; # manual cleanup now
      bdoc = "brew doctor";                    # health check
      bfile = "bat \"$HOMEBREW_BUNDLE_FILE\""; # view the generated Brewfile
    };
  };
}

#!/usr/bin/env bash

# Homebrew bootstrap helpers.
#
# nix-darwin manages Homebrew's *contents* but cannot install Homebrew itself,
# and it cannot take over apps that were installed by hand. These functions
# cover both one-time gaps. See the Homebrew section of README.md.
#
# NOTE: unlike nixeval.sh these are not `export -f`'d - they are called in the
#       same shell that sources this file, and `export -f` is a bashism that
#       dumps function bodies when sourced from zsh.

# Resolve the brew binary for this architecture.
# Usage: brew_bin
brew_bin() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    echo /opt/homebrew/bin/brew
  elif [[ -x /usr/local/bin/brew ]]; then
    echo /usr/local/bin/brew
  else
    return 1
  fi
}

# Install Homebrew if it is not already present. Idempotent.
# Usage: brew_install
brew_install() {
  if brew_bin >/dev/null; then
    echo "Homebrew already installed at $(brew_bin)"
    return 0
  fi

  echo "Installing Homebrew..."
  # The official installer, verbatim. It needs an admin sudo password and,
  # unless $NONINTERACTIVE is set, a TTY to confirm at the prompt.
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
    echo "Error: Homebrew installation failed" >&2
    return 1
  }

  brew_bin >/dev/null || {
    echo "Error: Homebrew installed but brew not found on any known prefix" >&2
    return 1
  }
  echo "Homebrew installed at $(brew_bin)"
}

# Write the declared Brewfile to stdout.
#
# This evaluates the config rather than reading the generated Brewfile out of
# the nix store, because the store path does not exist until the system has
# been built - and bootstrapping necessarily happens before the first build.
#
# Usage: brew_brewfile <config_path>
# Example: brew_brewfile "/path/to/nix#darwinConfigurations.host.config"
brew_brewfile() {
  local config_path="${1:-}"

  if [[ -z "$config_path" ]]; then
    echo "Error: brew_brewfile requires a config_path" >&2
    return 1
  fi

  nix eval --raw "$config_path.homebrew.brewfile"
}

# Paths brew would place for a cask's `app` stanzas, one per line (empty if the
# cask has none). `brew info` lists them as "<Name>.app (App)"; a bare name
# lands in the default appdir.
#
# Usage: brew_cask_apps <brew_bin> <token>
brew_cask_apps() {
  "$1" info --cask "$2" 2>/dev/null |
    sed -n '/^==> Artifacts$/,/^==> /p' |
    sed -n 's/ (App)$//p' |
    sed 's|^\([^/]\)|/Applications/\1|'
}

# Take over apps that are already installed by hand, so `brew bundle` does not
# fail with "It seems there is already an App at ...".
#
# `brew list --cask` is a *receipt* check, not a reality check, so a bare skip
# on it is not enough:
#
#   - receipt present, app gone (deleted or a half-finished install): `brew
#     bundle` skips it too, so nothing ever repairs it. Reinstall - there is no
#     app on disk to adopt.
#   - no `app` stanza at all (installer-script casks such as blockblock, which
#     install into /Library): nothing to adopt and nothing to verify, so the
#     receipt has to be taken at its word.
#   - no receipt: the hand-installed case `--adopt` exists for. Adoption
#     requires the installed version to match the cask's.
#
# Failures are reported at the end with the fallback (delete the app, let brew
# install it fresh).
#
# Usage: brew_adopt <config_path>
brew_adopt() {
  local config_path="${1:-}"
  local brew
  brew="$(brew_bin)" || { echo "Error: Homebrew is not installed" >&2; return 1; }

  local brewfile
  brewfile="$(brew_brewfile "$config_path")" || return 1

  # Cask tokens never contain whitespace, so word splitting here is safe and
  # keeps the loop in this shell (a pipe would subshell away the failed list).
  local tokens token failed=()
  tokens="$(printf '%s\n' "$brewfile" | sed -n 's/^cask "\([^"]*\)".*/\1/p')"

  if [[ -z "$tokens" ]]; then
    echo "No casks declared, nothing to adopt."
    return 0
  fi

  local apps app missing
  for token in $tokens; do
    if "$brew" list --cask "$token" >/dev/null 2>&1; then
      apps="$(brew_cask_apps "$brew" "$token")"

      if [[ -z "$apps" ]]; then
        echo "  skip    $token (managed; no app artifact to verify)"
        continue
      fi

      missing=()
      while IFS= read -r app; do
        [[ -e "$app" ]] || missing+=("$app")
      done <<<"$apps"

      if (( ${#missing[@]} == 0 )); then
        echo "  skip    $token (already managed by Homebrew)"
        continue
      fi

      echo "  repair  $token (receipt present, missing ${missing[0]})"
      if ! "$brew" reinstall --cask "$token"; then
        failed+=("$token")
      fi
      continue
    fi

    echo "  adopt   $token"
    if ! "$brew" install --cask --adopt "$token"; then
      failed+=("$token")
    fi
  done

  if (( ${#failed[@]} )); then
    echo
    echo "Could not adopt or repair: ${failed[*]}"
    echo "Adoption is usually a version mismatch - the installed app is older"
    echo "than the cask. A repair is usually a download that never finished."
    echo "Either update the app and retry, or move it to the Trash and let"
    echo "\`just build\` install it fresh, e.g.:"
    echo
    echo "  mv \"/Applications/<App Name>.app\" ~/.Trash/"
    return 1
  fi

  echo "All declared casks are under Homebrew's control."
}

# Full bootstrap: install Homebrew, then adopt already-installed casks.
# Usage: brew_bootstrap <config_path>
brew_bootstrap() {
  local config_path="${1:-}"

  brew_install || return 1
  echo

  echo "Adopting already-installed casks..."
  brew_adopt "$config_path" || true # non-fatal: reported, then continue
  echo

  echo "Next: run \`just build\` to apply the declared Homebrew state."
}

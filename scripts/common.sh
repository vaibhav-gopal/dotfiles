#!/usr/bin/env bash

# ─── Configuration ──────────────────────────────────────────────────────────
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
MODES_NIX="$DOTFILES_DIR/modes.nix"
USER_NIX_CONF="$HOME/.config/nix/nix.conf"
DOTFILES_NIX_CONF="$DOTFILES_DIR/nix/nix.conf"
FLAKE="$DOTFILES_DIR#homeConfigurations"
# ----------------------------------------------------------------------------

# ─── Functions ──────────────────────────────────────────────────────────────
print_available_modes() {
  GREEN='\033[1;32m'
  BOLD='\033[1m'
  RESET='\033[0m'

  echo -e "\n📋 ${BOLD}Available configurations (name and usage):${RESET}\n"

  nix eval --impure --json --expr \
    "map (x: x.modeName) (import \"$MODES_NIX\" { hmPaths = import \"$DOTFILES_DIR/flake.nix\".hmPaths; })" \
    | jq -r '.[]' \
    | while IFS= read -r mode; do
        # Pad and align into columns
        printf "    %-18s  ${GREEN}\$ HM_MODE_NAME=%s nix develop${RESET}\n" "$mode" "$mode"
      done
}
# ----------------------------------------------------------------------------
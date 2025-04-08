#!/usr/bin/env bash

set -euo pipefail

# ─── Configuration ──────────────────────────────────────────────────────────
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
MODES_NIX="$DOTFILES_DIR/modes.nix"
USER_NIX_CONF="$HOME/.config/nix/nix.conf"
DOTFILES_NIX_CONF="$DOTFILES_DIR/nix/nix.conf"
FLAKE="$DOTFILES_DIR#homeConfigurations"
# ----------------------------------------------------------------------------

# ─── Helper: Show valid mode names ──────────────────────────────────────────
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

# Read from argument or fallback to HM_MODE_NAME
CONFIG_NAME="${1:-${HM_MODE_NAME:-}}"

# ─── Handle missing mode ─────────────────────────────────────────────────────
if [ -z "$CONFIG_NAME" ]; then
  echo "❌ No Home Manager configuration specified."
  echo "👉 Usage: ./bootstrap.sh <mode-name> or set HM_MODE_NAME"
  print_available_modes
  exit 1
fi

echo "🚀 Bootstrapping or switching Home Manager (config: $CONFIG_NAME)..."

# Ensure ~/.config/nix exists
mkdir -p "$(dirname "$USER_NIX_CONF")"

# Symlink nix.conf if not already linked
if [ -e "$USER_NIX_CONF" ] || [ -L "$USER_NIX_CONF" ]; then
  echo "⚠️  $USER_NIX_CONF already exists. Skipping symlink."
else
  echo "🔗 Symlinking nix.conf from dotfiles..."
  ln -s "$DOTFILES_NIX_CONF" "$USER_NIX_CONF"
fi

# ─── Validate the configuration exists ───────────────────────────────────────
echo "🔍 Validating configuration: $CONFIG_NAME..."

VALID_NAMES=$(nix eval --impure --expr "map (x: x.modeName) (import \"$MODES_NIX\" { hmPaths = import \"$DOTFILES_DIR/flake.nix\".hmPaths; })" --json | jq -r '.[]' || true)

if ! echo "$VALID_NAMES" | grep -qx "$CONFIG_NAME"; then
  echo "❌ Configuration '$CONFIG_NAME' not found in modes.nix."
  print_available_modes
  exit 1
fi

# ─── Build and activate the configuration ────────────────────────────────────
echo "🔧 Building Home Manager activation package..."
if ! nix build --extra-experimental-features "nix-command flakes" \
  "$FLAKE.$CONFIG_NAME.activationPackage"; then
  echo "❌ Build failed. Aborting bootstrap."
  exit 1
fi

echo "🏃 Activating configuration..."
./result/activate

# Clean up result symlink
rm -f ./result

echo "✅ Success! Home Manager config '$CONFIG_NAME' is now active. 🎉"

# Exit the shell if called in a devShell
exit 0

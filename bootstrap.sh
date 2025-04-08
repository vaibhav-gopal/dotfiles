#!/usr/bin/env bash

set -euo pipefail

# --- CONFIG ---
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
MODES_NIX="$DOTFILES_DIR/modes.nix"
USER_NIX_CONF="$HOME/.config/nix/nix.conf"
DOTFILES_NIX_CONF="$DOTFILES_DIR/nix/nix.conf"
# ----------------

# Use argument or fallback to HM_MODE_NAME
CONFIG_NAME="${1:-${HM_MODE_NAME:-}}"

if [ -z "$CONFIG_NAME" ]; then
  echo "❌ No Home Manager configuration specified."
  echo "👉 Usage: ./bootstrap.sh <mode-name> or set HM_MODE_NAME"

  if [ -f "$MODES_NIX" ]; then
    echo "📋 Available configurations:"
    nix eval --impure --expr "map (x: x.modeName) (import \"$MODES_NIX\" { hmPaths = import \"$DOTFILES_DIR/flake.nix\".hmPaths; })" --json 2>/dev/null | jq -r '.[]' || true
  fi

  exit 1
fi

echo "🚀 Bootstrapping or switching Home Manager (config: $CONFIG_NAME)..."

# Ensure ~/.config/nix exists
mkdir -p "$(dirname "$USER_NIX_CONF")"

# Symlink nix.conf if needed
if [ -e "$USER_NIX_CONF" ] || [ -L "$USER_NIX_CONF" ]; then
  echo "⚠️  $USER_NIX_CONF already exists. Skipping symlink."
else
  echo "🔗 Symlinking nix.conf from dotfiles..."
  ln -s "$DOTFILES_NIX_CONF" "$USER_NIX_CONF"
fi

# Validate CONFIG_NAME exists in modes.nix
echo "🔍 Validating configuration: $CONFIG_NAME..."

VALID_NAMES=$(nix eval --impure --expr "map (x: x.modeName) (import \"$MODES_NIX\" { hmPaths = import \"$DOTFILES_DIR/flake.nix\".hmPaths; })" --json | jq -r '.[]' || true)

if ! echo "$VALID_NAMES" | grep -qx "$CONFIG_NAME"; then
  echo "❌ Configuration '$CONFIG_NAME' not found in modes.nix."
  echo "✅ Available configurations:"
  echo "$VALID_NAMES" | sed 's/^/  - /'
  exit 1
fi

# Build and activate the configuration
echo "🔧 Building Home Manager activation package..."
nix build --extra-experimental-features "nix-command flakes" \
  "$DOTFILES_DIR#homeConfigurations.$CONFIG_NAME.activationPackage"

echo "🏃 Activating configuration..."
./result/activate

echo "✅ Success! Home Manager config '$CONFIG_NAME' is now active. 🎉"

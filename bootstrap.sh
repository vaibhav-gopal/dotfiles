#!/usr/bin/env bash

set -euo pipefail

# --- CONFIG ---
DOTFILES_DIR="$HOME/dotfiles"
USER_NIX_CONF="$HOME/.config/nix/nix.conf"
DOTFILES_NIX_CONF="$DOTFILES_DIR/nix/nix.conf"
HOME_MANAGER_BRANCH="release-24.11"  # You can change this to another branch/tag if needed
# ----------------

echo "🚀 Bootstrapping Home Manager (flake-based)..."

# 1. Ensure ~/.config/nix exists
mkdir -p "$(dirname "$USER_NIX_CONF")"

# 2. Symlink nix.conf
if [ -e "$USER_NIX_CONF" ] || [ -L "$USER_NIX_CONF" ]; then
  echo "⚠️  $USER_NIX_CONF already exists. Skipping symlink."
else
  echo "🔗 Symlinking nix.conf from dotfiles..."
  ln -s "$DOTFILES_NIX_CONF" "$USER_NIX_CONF"
fi

# 3. Run home-manager using the flake
echo "🏡 Running home-manager flake switch..."
nix run --extra-experimental-features "nix-command flakes" \
  "home-manager/$HOME_MANAGER_BRANCH" -- switch --flake "$DOTFILES_DIR"

echo "✅ Done! Your environment is now bootstrapped with Home Manager 🎉"


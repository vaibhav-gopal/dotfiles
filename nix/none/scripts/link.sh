#!/usr/bin/env bash

# path definitions
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
USER_NIX_CONF="$HOME/.config/nix/nix.conf"
DOTFILES_NIX_CONF="$DOTFILES_DIR/nix/none/nix.conf"

# Ensure ~/.config/nix exists
mkdir -p "$(dirname "$USER_NIX_CONF")"

# Symlink nix.conf if not already linked
if [ -e "$USER_NIX_CONF" ] || [ -L "$USER_NIX_CONF" ]; then
  echo "⚠️  $USER_NIX_CONF already exists. Skipping symlink."
else
  echo "🔗 Symlinking nix.conf from dotfiles..."
  ln -s "$DOTFILES_NIX_CONF" "$USER_NIX_CONF"
fi

exit 0
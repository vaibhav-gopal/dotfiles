# Dotfiles: Home Manager Flake Setup

This repository defines a modular, multi-mode Home Manager setup using Nix flakes.
It supports:
- Multiple systems and multiple configurations
- Reusable feature modules (like `cargo`, `nvm`, `shell`, etc.)
- Organized `.d` fragments for shell hooks and modular configuration

## Getting Started

Install nix/nixpkgs (prefer the multi-user installation)

Then follow the flake-based home-manager initial command to init home-manager and its first generation

Then enjoy!

Tips:
- Flakes only evaluates files tracked by git
- Clean up the nix store via nix-collect-garbage, with options to delete old generations among others
- Use nix profile to imperatively install packages instead through home-manager config
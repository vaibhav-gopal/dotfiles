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


## IMPORTANT LINKS

[NIX FLAKE GUIDE (nix doesn't provide an official one, cringe)](https://nixos-and-flakes.thiscute.world)

[NIX LANG BUILTINS](https://nix.dev/manual/nix/2.25/language/builtins)

[NIX LANG BASICS](https://nix.dev/tutorials/nix-language)

[HOME-MANAGER BASICS](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nix-darwin-module)

[HOME-MANAGER OPTIONS](https://nix-community.github.io/home-manager/options.xhtml)

[HOME-MANAGER NIXOS MODULE OPTIONS](https://nix-community.github.io/home-manager/nixos-options.xhtml)

[HOME-MANAGER NIX-DARWIN MODULE OPTIONS](https://nix-community.github.io/home-manager/nix-darwin-options.xhtml)

[NIX-DARWIN STARTER](https://github.com/nix-darwin/nix-darwin)

[NIX-DARWIN OPTIONS](https://nix-darwin.github.io/nix-darwin/manual/index.html)
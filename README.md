# Dotfiles: Home Manager Flake Setup

This repository defines a modular, multi-mode Home Manager setup using Nix flakes.
It supports:
- Multiple systems and multiple configurations
- Uses `options.*` for modularizing both home-manager features and nixos features
- Enables per-user overrides for home-manager setups and per-system overrides for nixos archetypes
- Organized `.d` fragments for shell hooks and modular configuration

## Getting Started

Pre-Setup:
- Install nixos/nixos-wsl
- OR Install nix with the multi-user installation

1. If on nixos/nixos-wsl will need to first setup `/etc/nixos/configuration.nix` with enabling experimental features. If on nix-darwin (or standalone nix) go into `/etc/nix/nix.conf` and enable experimental features.
2. Using `nix develop` in the `dotfiles` root directory, will install `just` (task runner), `git` (version control), `gh` (github CLI, clone private repos easier) and `vim` (editor) into the shell session. (recommended)
3. OR Using `nix profile install` or `nix profile add`, add `just`, `git`, `gh`, and `vim` into the current user profile (will have to remove later!)
4. You will need to setup the `.env` file in `dotfiles/env/.env` with the approriate environment variables
5. Then run `just build` (if you are on nix-darwin for the first time, run `just darwin_init` to download nix-darwin and install for the first time)
6. Enjoy!

## TIPS

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
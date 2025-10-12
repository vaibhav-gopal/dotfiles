# Dotfiles: Home Manager Flake Setup

This repository defines a modular, multi-mode Home Manager setup using Nix flakes.
It supports:
- Multiple systems (`modeConfig.system`)
- Per-machine configurations (`modeConfig.modeName`)
- Reusable feature modules (like `cargo`, `nvm`, `shell`, etc.)
- Organized `.d` fragments for shell hooks and modular configuration

## Getting Started

Install nix/nixpkgs (prefer the multi-user installation)

## Structure Overview

```
.
├── flake.nix
├── bootstrap.sh
├── modes.nix
├── home/
│   ├── common/
│   │   ├── default.nix        ← Shared Home Manager modules
│   │   └── configs/
│   │       ├── shell.d/       ← Shell init/profile/env fragments (zsh/bash)
│   │       ├── vim.d/         ← Shared vim/nvim config (init.vim/init.lua)
│   │       └── term.d/        ← Terminal configs like zellij.kdl
│   └── <username>_<mode>/
│       ├── home.nix           ← Mode-specific Home Manager config
│       └── localconfigs/      ← Optional `.d` shell overrides (overrides common and feature configs)
├── features/
│   └── <feature>/
│       ├── default.nix        ← Feature logic (packages, config, session vars)
│       ├── shell.d/           ← Optional shell fragments (e.g. cargo.zshrc)
│       └── <feature>.d/       ← Optional feature-specific configuration
```

## How to Build or Switch

### With `nix develop`
```sh
HM_MODE_NAME=vaibhav@wsl2 nix develop
```
This loads a development shell, bootstraps Home Manager using `bootstrap.sh`, and builds the selected mode config.

### Home Manager Commands
```sh
hms         # = home-manager switch --flake $DOTFILES_DIR#$HM_MODE_NAME
hml         # = home-manager generations
hmpkgs      # = home-manager packages
```

## Design Philosophy

### Modular `.d` Fragments
Each config layer can define shell integration in `.d` folders. These are sourced in the following order:

```text
common/configs/shell.d/*.zshrc
↓
features/<feature>/shell.d/*.zshrc (if feature is enabled)
↓
home/<user>_<mode>/localconfigs/shell.d/*.zshrc (optional overrides)
```

This applies to:
- `*.zshenv`, `*.zprofile`
- `*.bashrc`, `*.profile`
- Any other shell fragment pattern your system supports

### Features
Each `features/<name>/default.nix` can:
- Add packages to `home.packages`
- Set `home.sessionVariables`
- Provide shell or application configuration
- Define fragments in `shell.d` or `feature.d/`
- Optionally install/setup tools via `home.activation`

### Config Scoping
- `common/` → shared across all systems
- `features/` → opt-in modular configs (enabled per mode)
- `localconfigs/` → mode-specific overrides for both common and feature behavior

### Symlinking Configuration
Home Manager modules symlink important dotfiles (e.g. `.vimrc`, `init.lua`, `starship.toml`) into the user's home directory. These files can originate from:
- `common/configs/`
- `features/<feature>.d/`
- `localconfigs/` (if overriding is necessary)

These symlinks are declared in the corresponding module using `home.file`.

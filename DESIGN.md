# Design Philosophy

## Organization

### NixOS

- `nix` directory contains different nixos archetypes
- `nix/modules` directory contains shared nixos modules, for use across all nixos archetypes
- `nix/[arch]` directory contains the base `flake.nix` and `justfile`
- `nix/[arch]/[hostname]` directory contains the host/system specific overrides
- `nix/[arch]/modules` directory contains core configs, and modules, modularized with `options.*` which enables the configs in `nix/[arch]/[hostname]` to override/customize them

### Home-manager

- `home` directory contains the base `home.nix` that imports the system specific override config and modules
- `home/modules` directory contains the base `default.nix` and `base.nix`, which imports listed modules and enables them and provides universal core home-manager configs.
- `home/modules/[feature]` directory contains various modules, which includes `options.*` for modular/parameterized configurations and optionally `*.d` data directories for config files
- `home/[arch]` directory contains the per-nixtype config overrides
- `home/[arch]/[system_name]` directory contains the per-system-per-nixtype config overrides
- `home/[arch]/modules/[feature]` directory contains various per-nixtype modules, which includes `options.*` for modular/parameterized configurations and optionally `*.d` data directories for config files

### Other

- `dev-utils` directory contains various nix development examples and templates to use / copy
- `user` directory contains data / tools not associated with directly used by nix configs, but are still "dotfiles" related (i.e. initial system setup / user system configurations)

## Terminal Themes / Colors (Involves vim/nvim and any other pretty print CLI)
Just use a terminal emulator and choose a theme from there ; much too much work to setup up a theme for each every single terminal application ; forego it please (see term.nix)

## Keyboard Shortcuts / Application Nesting

Follow modifier key layers like below. And keep application nesting to a minimum, as hotkeys/shortcuts were designed with the below in mind...

Top Level (compositor) (Level 0):

- `meta`+`*` (globals, compositor / system - level shortcuts)
- reserved shortcuts for linux kernel (`ctrl`+`alt`+`Fn` for tty switching, etc...)

### GUI Mode

Any Application (Level 1+):

- `ctrl`+`*` (anything)
- `alt`+`*` (anything)
- `Fn` (anything)

### Terminal / TUI Mode

Terminal Emulator + Terminal Multiplexer (Level 1):

- `ctrl`  (shell hotkeys + tty signals)
- `ctrl`+`shift` (terminal multiplexer shortcuts + terminal emulator shortcuts)
- `Fn` ( F1-F4/F9-F12 terminal multiplexer shortcuts + F11 fullscreen)

Terminal Applications (vim, nvim, zed, yazi, etc...) (Level 2):

- `ctrl`  (legacy hotkeys)
- `Fn` (F5-F8 menus / shortcuts)
- `alt`/`alt`+`shift` (useful hotkeys ; native)
- leader key (useful hotkeys ; grouping)
- `ctrl`+`alt`/`ctrl`+`alt`+`shift` (useful hotkeys ; plugins/extensions)
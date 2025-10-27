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
2. Using `nix profile install` or `nix profile add`, add `git` and `gh` (will have to remove later)
3. Setup `gh` by using `gh auth login` then clone the dotfiles repo with `gh repo clone [repo_path]`
4. Using `nix develop` in the `dotfiles` root directory, will install `just` (task runner), `vim` (editor) into the shell session and `glow` (markdown previewer). (recommended)
5. OR Using `nix profile install` or `nix profile add`, add the above packages into the current user profile as well
6. You will need to setup the `.env` file in `dotfiles/env/.env` with the approriate environment variables
7. Then run `just build` (if you are on nix-darwin for the first time, run `just darwin_init` to download nix-darwin and install for the first time)
8. Enjoy!

## Organization

### NixOS
- `nix` directory contains different nixos archetypes
- `nix/[arch]` directory contains the base `flake.nix` and `justfile`
- `nix/[arch]/[hostname]` directory contains the host/system specific overrides
- `nix/[arch]/core` directory contains base configurations for that nixos archetype, also impors features
- `nix/[arch]/core/features` directory contains features, modularized with `options.*` which enables the configs in `nix/[arch]/[hostname]` to override/customize them

### Home-manager
- `home` directory contains the base `home.nix` that imports the system specific override config and features
- `home/features` directory contains the base `default.nix` and `base.nix`, which imports listed features and enables them and provides universal core home-manager configs.
- `home/[username]_[hostname]` directory contains the per-user-per-system config overrides
- `home/features/[feature]` directory contains the features `default.nix` entry point, which includes `options.*` for modular/parameterized configurations, allowing overriding/configuration via `home/[username]_[hostname]`
- `home/features/[feature]/[fragment].d` directory contains config files, either used by the current feature or by other features

### Templates
- `templates` directory contains various nix development templates to use / copy
- `templates/[template]` directory contains the `flake.nix` template

## TIPS

### Justfiles and dotfiles
1. use `just` in the root `dotfiles` directory to list all possible commands (very useful, go from there, read descriptions)
2. cannot directly use nested justfiles since they require certain env variables to be set and loaded (unless run from root justfile or with env variables explicity set in shell before running)

### nix treats quoted vs raw paths differently
1. raw paths get included in the nix store and evaluated immediately
2. string paths do not get included in the nix store by default and are not evaluated immediately (you might get file/folder not found error with a super long nix store hash)

### accelerating dotfiles debugging (for config files specifically)
1. We can use `mkOutOfStoreSymlink` which skips the nix store creation for the config files, using the absolute path of the config in the dotfiles directory (NOTE: ENSURE YOU PASS THE PATH AS A STRING, ALSO PATH MUST BE AN ABSOLUTE PATH!)
2. This enables changes to take effect immediately, significantly speeding up dotfiles debugging (for linked files, like configs)

### Base 3 output attributes of every module
1. `options` : defines options that are available to set/get via `config.*`
2. `config` : allows setting/getting of options defined in `options.*`
    - This is actually the `output` of the module, and everything is implicitly prepended this accessor, IF the `config` attribute isn't explicity referenced in the body of the module
3. `imports` : defines other module imports

### Git
- Flakes only evaluates new files tracked by git

### Disk Space / Garbage collection
- Clean up the nix store via nix-collect-garbage, with options to delete old generations among others (use `just gc` and check with `just size`)

### Imperative package installs
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
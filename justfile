# justfile functions (IMPORTANT!) (e.g. justfile() and justfile_directory())
# see https://just.systems/man/en/functions.html

# justfile constants (for string styling and other things)
# see https://just.systems/man/en/constants.html

# justfile file settings
# see https://just.systems/man/en/settings.html

# justfile recipe attributes (per recipie settings)
# see https://just.systems/man/en/attributes.html

# command prefixes
# `@` - silent command
# `-` - failable command

# recipe prefixes
# `@` - silent recipe
# `_` - private recipe

# See the .template-env file for more info on why/how each of these are used
dotenv-dir := 'env'
set dotenv-filename := 'env/.env'
set dotenv-required
nixtype := env('NIXTYPE')
nixconfig := env('NIXCONFIG')
nixpkgs := env('NIXCONFIG_VERSION')
nixusername := env('NIXCONFIG_USERNAME')

import 'nix/nix-darwin/justfile'
import 'nix/nixos/justfile'
import 'nix/nixos-wsl/justfile'

# List all recipes
default:
    @echo -e "{{BOLD + BLUE}}Listing all recipes for dotfiles{{NORMAL}}"
    @just --list --justfile {{justfile()}} --list-heading '' --unsorted

# Print out .env variables [NIXTYPE, NIXCONFIG, NIXCONFIG_VERSION, NIXCONFIG_USERNAME]
status:
    @echo -e "{{BOLD + BLUE}}Dotfiles config:{{NORMAL}}"
    @while IFS= read -r line; do echo "{{BOLD + CYAN}}$line{{NORMAL}}"; done < {{dotenv-dir / ".env"}}

# garbage collect nix store entries and generations older than 7 days (--force = delete all old generations)
gc *flags:
    sudo -H nix-collect-garbage \
    {{if flags =~ '(^|[[:space:]])--force($|[[:space:]])' { '-d' } else {'--delete-older-than 7d'} }}

# print out current disk usage for /nix/store
size:
    sudo -H du -sh /nix/store

# build using .env variables [NIXTYPE, NIXCONFIG, NIXCONFIG_VERSION, NIXCONFIG_USERNAME]
[group('archetype')]
build:
    @echo -e "{{BOLD + BLUE}}Building {{nixtype}} for config '{{nixconfig}}' @ {{nixpkgs}}{{NORMAL}}"
    @just --justfile {{justfile()}} {{nixtype}}_build

# Updates the current flake.nix for NIXTYPE
[group('archetype')]
update:
    @echo -e "{{BOLD + BLUE}}Updating the flake.nix for {{nixtype}}{{NORMAL}}"
    @just --justfile {{justfile()}} {{nixtype}}_update

# Upgrades the nixpkgs channel and nix profile packages.
[group('archetype')]
upgrade:
    @echo -e "{{BOLD + BLUE}}Upgrading the nix channels and nix profile packages for {{nixtype}}{{NORMAL}}"
    @just --justfile {{justfile()}} {{nixtype}}_upgrade

# Match the nix channels with the nixos/nix-darwin lts version. (Unable to install the latest packages on a per-package basis if needed)
[group('archetype')]
lts-channel:
    @echo -e "{{BOLD + RED}}Warning! This will remove the `nixpkgs` channel and replace it with the nixos-XX version!{{NORMAL}}"
    @just --justfile {{justfile()}} {{nixtype}}_lts-channel

# Update the nix channels with unstable. (Recommended)
[group('archetype')]
unstable-channel:
    @echo -e "{{BOLD + RED}}Warning! This will remove the `nixpkgs` channel and replace it with the nixos-unstable version!{{NORMAL}}"
    @just --justfile {{justfile()}} {{nixtype}}_unstable-channel

# list out all features
[group('archetype')]
features:
    @just --justfile {{justfile()}} arch-features
    @just --justfile {{justfile()}} home-features
    @just --justfile {{justfile()}} system-features

# list out all system wide features
[group('archetype')]
arch-features:
    @echo -e "{{BOLD + BLUE}}Dotfiles system-wide features:{{NORMAL}}"
    @just --justfile {{justfile()}} {{nixtype}}_arch-features

# list out all home-manager common features
[group('archetype')]
home-features:
    @echo -e "{{BOLD + BLUE}}Dotfiles home-manager common features:{{NORMAL}}"
    @just --justfile {{justfile()}} {{nixtype}}_home-features

# list out all home-manger per-system features
[group('archetype')]
system-features:
    @echo -e "{{BOLD + BLUE}}Dotfiles home-manager per-system features:{{NORMAL}}"
    @just --justfile {{justfile()}} {{nixtype}}_system-features
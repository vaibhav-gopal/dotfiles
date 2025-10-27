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

dotenv-dir := 'env'
set dotenv-filename := 'env/.env'
set dotenv-required
nixtype := env('NIXTYPE')
nixbuildrecipe := env('NIXBUILDRECIPE')
nixconfig := env('NIXCONFIG')
nixpkgs := env('NIXCONFIG_VERSION')

import 'nix/nix-darwin/justfile'
import 'nix/nixos/justfile'
import 'nix/nixos-wsl/justfile'

# List all recipes
default:
    @echo -e "{{BOLD + BLUE}}Listing all recipes for dotfiles{{NORMAL}}"
    @just --list --justfile {{justfile()}} --list-heading '' --unsorted

# Print out .env variables [NIXTYPE, NIXBUILDRECIPE, NIXCONFIG, NIXCONFIG_VERSION]
status:
    @echo -e "{{BOLD + BLUE}}Dotfiles config:{{NORMAL}}"
    @while IFS= read -r line; do echo "{{BOLD + CYAN}}$line{{NORMAL}}"; done < {{dotenv-dir / ".env"}}

# build using .env variables [NIXTYPE, NIXBUILDRECIPE, NIXCONFIG, NIXCONFIG_VERSION] (specify config name or load from $NIXCONFIG)
build config=nixconfig:
    @echo -e "{{BOLD + BLUE}}Building {{nixtype}} for config '{{nixconfig}}' @ {{nixpkgs}} with recipe {{nixbuildrecipe}}{{NORMAL}}"
    @just --justfile {{justfile()}} {{nixbuildrecipe}} {{config}}

# Run a recipe (interactive)
run:
    @echo -e "{{BOLD + BLUE}}Interactively running a recipe from {{justfile_directory()}}...{{NORMAL}}"
    -@just --choose --justfile {{justfile()}}

# Updates the nixpkgs channel and upgrades nix profile packages.
upgrade:
    sudo -H nix-channel --update
    sudo -H nix profile upgrade --all

# garbage collect nix store entries and generations older than 7 days (--force = delete all old generations)
gc *flags:
    sudo -H nix-collect-garbage \
    {{if flags =~ '(^|[[:space:]])--force($|[[:space:]])' { '-d' } else {'--delete-older-than 7d'} }}

# print out current disk usage for /nix/store
size:
    sudo -H du -sh /nix/store

# list out all enabled features by looking at the feature list outputs (see all **/features/default.nix in dotfiles/home)
[group("home-manager")]
features:
    @echo -e "{{BOLD + BLUE}}Dotfiles home-manager enabled features:{{NORMAL}}"
    @for file in {{dotenv-dir / "*.temp"}}; do echo "{{BOLD + CYAN}}[$file]: {{NORMAL}}" && cat "$file" && echo ""; done
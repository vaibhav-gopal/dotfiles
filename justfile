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

set dotenv-filename := 'env/.env'
set dotenv-required
nixarch := env('NIXARCH')
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

# Print out .env variables [NIXARCH, NIXBUILDRECIPE, NIXCONFIG, NIXCONFIG_VERSION]
status:
    @echo -e "{{BOLD + BLUE}}dotfiles config: NIXARCH={{nixarch}} , NIXBUILDRECIPE={{nixbuildrecipe}} , NIXCONFIG={{nixconfig}} , NIXCONFIG_VERSION={{nixpkgs}}{{NORMAL}}"

# build using .env variables [NIXARCH, NIXBUILDRECIPE, NIXCONFIG, NIXCONFIG_VERSION] (specify config name or load from $NIXCONFIG)
build config=nixconfig:
    @echo -e "{{BOLD + BLUE}}Building {{nixarch}} for config '{{nixconfig}}' @ {{nixpkgs}} with recipe {{nixbuildrecipe}}{{NORMAL}}"
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
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
scripts-dir := 'nix' / 'scripts'
eval-script := 'nixeval.sh'
set dotenv-filename := '.env'
set dotenv-required
nixtype := env('NIXTYPE')
nixconfig := env('NIXCONFIG')
nixpkgs := env('NIXCONFIG_VERSION')
nixusername := env('NIXCONFIG_USERNAME')

import 'nix/justfile'

#####################################
########## CORE UTILITIES ###########
#####################################

# List all recipes
default:
    @echo -e "{{BOLD + BLUE}}Listing all recipes for dotfiles{{NORMAL}}"
    @just --list --justfile {{justfile()}} --list-heading '' --unsorted

# Print out .env variables [NIXTYPE, NIXCONFIG, NIXCONFIG_VERSION, NIXCONFIG_USERNAME]
status:
    @echo -e "{{BOLD + BLUE}}Dotfiles config:{{NORMAL}}"
    @while IFS= read -r line; do echo "{{BOLD + CYAN}}$line{{NORMAL}}"; done < ".env"

# garbage collect nix store entries and generations older than 7 days (--force = delete all old generations)
gc *flags:
    sudo -H nix-collect-garbage \
    {{if flags =~ '(^|[[:space:]])--force($|[[:space:]])' { '-d' } else {'--delete-older-than 7d'} }}

# print out current disk usage for /nix/store
size:
    sudo -H du -sh /nix/store

# Switch / rebuild nixos configuration for the first time (mainly for nix-darwin ; installs nix-darwin)
init:
    @echo -e "{{BOLD + BLUE}}Building first-time {{nixtype}} for config '{{nixconfig}}' @ {{nixpkgs}}{{NORMAL}}"
    @just --justfile {{justfile()}} _{{nixtype}}_init

# Switch / rebuild nixos configuration (with updated kernel or boot params ; applies changes only on next boot) (if supported on archetype)
buildboot:
    @echo -e "{{BOLD + BLUE}}Building {{nixtype}} for config '{{nixconfig}}' @ {{nixpkgs}} : Applying on next boot{{NORMAL}}"
    @just --justfile {{justfile()}} _{{nixtype}}_build_boot

# build using .env variables [NIXTYPE, NIXCONFIG, NIXCONFIG_VERSION, NIXCONFIG_USERNAME]
build:
    @echo -e "{{BOLD + BLUE}}Building {{nixtype}} for config '{{nixconfig}}' @ {{nixpkgs}}{{NORMAL}}"
    @just --justfile {{justfile()}} _{{nixtype}}_build

# Updates the current flake.nix for NIXTYPE
update:
    @echo -e "{{BOLD + BLUE}}Updating the flake.nix for {{nixtype}}{{NORMAL}}"
    @just --justfile {{justfile()}} _{{nixtype}}_update

# Upgrades the nixpkgs channel and nix profile packages.
upgrade:
    @echo -e "{{BOLD + BLUE}}Upgrading the nix channels and nix profile packages for {{nixtype}}{{NORMAL}}"
    @just --justfile {{justfile()}} _{{nixtype}}_upgrade

# Match the nix channels with the nixos/nix-darwin lts version. (Unable to install the latest packages on a per-package basis if needed)
lts-channel:
    @echo -e "{{BOLD + RED}}Warning! This will remove the `nixpkgs` channel and replace it with the nixos-XX version!{{NORMAL}}"
    @just --justfile {{justfile()}} _{{nixtype}}_lts-channel

# Update the nix channels with unstable. (Recommended)
unstable-channel:
    @echo -e "{{BOLD + RED}}Warning! This will remove the `nixpkgs` channel and replace it with the nixos-unstable version!{{NORMAL}}"
    @just --justfile {{justfile()}} _{{nixtype}}_unstable-channel

#####################################
####### ARCHETYPE EVALUATIONS #######
#####################################

# evaluate an arbitrary attribute for system / nix arch options
[group('eval')]
evalsysoptions attrpath:
    @just --justfile {{justfile()}} _{{nixtype}}_check
    @echo -e "{{BOLD + BLUE}}Dotfiles system configuration eval, attempting to access {{attrpath}} in {{nixconfig}}.config {{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval_options "$(just --justfile {{justfile()}} _{{nixtype}}_options)" "{{attrpath}}"

# evaluate an arbitrary attribute for system / nix arch configs
[group('eval')]
evalsysconfigs attrpath:
    @just --justfile {{justfile()}} _{{nixtype}}_check
    @echo -e "{{BOLD + BLUE}}Dotfiles system configuration eval, attempting to access {{attrpath}} in {{nixconfig}}.config {{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval "$(just --justfile {{justfile()}} _{{nixtype}}_system)" "{{attrpath}}"

# evaluate an arbitrary attribute for home-manager configs
[group('eval')]
evalhomeconfigs attrpath:
    @just --justfile {{justfile()}} _{{nixtype}}_check
    @echo -e "{{BOLD + BLUE}}Dotfiles home-manager configuration eval, attempting to access {{attrpath}} in {{nixconfig}}.config.home-manager.users.{{nixusername}} {{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval "$(just --justfile {{justfile()}} _{{nixtype}}_home)" "{{attrpath}}"

# evaluate an arbitrary attribute for home-manager options
[group('eval')]
evalhomeoptions attrpath:
    @just --justfile {{justfile()}} _{{nixtype}}_check
    @echo -e "{{BOLD + BLUE}}Dotfiles home-manager configuration eval, attempting to access {{attrpath}} in {{nixconfig}}.config.home-manager.users.{{nixusername}} {{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval_options "$(just --justfile {{justfile()}} _{{nixtype}}_home-options)" "{{attrpath}}"

# list out system core options and module options
[group('eval-all')]
sysoptions:
    @just --justfile {{justfile()}} _{{nixtype}}_check
    @echo -e "{{BOLD + BLUE}}Dotfiles system-wide core options:{{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval_options "$(just --justfile {{justfile()}} _{{nixtype}}_options)" "core"
    @echo -e "{{BOLD + BLUE}}Dotfiles system-wide module options:{{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval_options "$(just --justfile {{justfile()}} _{{nixtype}}_options)" "modules"

# list out system-wide core configs and module configs
[group('eval-all')]
sysconfigs:
    @just --justfile {{justfile()}} _{{nixtype}}_check
    @echo -e "{{BOLD + BLUE}}Dotfiles system-wide core configs:{{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval "$(just --justfile {{justfile()}} _{{nixtype}}_system)" "core"
    @echo -e "{{BOLD + BLUE}}Dotfiles system-wide features configs:{{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval "$(just --justfile {{justfile()}} _{{nixtype}}_system)" "features"

# list out home-manager common module options and nixtype module options
[group('eval-all')]
homeoptions:
    @just --justfile {{justfile()}} _{{nixtype}}_check
    @echo -e "{{BOLD + BLUE}}Dotfiles home-manager common features options:{{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval_options "$(just --justfile {{justfile()}} _{{nixtype}}_home-options)" "common"
    @echo -e "{{BOLD + BLUE}}Dotfiles home-manager per-system features options:{{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval_options "$(just --justfile {{justfile()}} _{{nixtype}}_home-options)" "nixtype"

# list out home-manager common module configs and nixtype module configs
[group('eval-all')]
homeconfigs:
    @just --justfile {{justfile()}} _{{nixtype}}_check
    @echo -e "{{BOLD + BLUE}}Dotfiles home-manager common features configs:{{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval "$(just --justfile {{justfile()}} _{{nixtype}}_home)" "common"
    @echo -e "{{BOLD + BLUE}}Dotfiles home-manager per-system features configs:{{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval "$(just --justfile {{justfile()}} _{{nixtype}}_home)" "nixtype"

# list out all system wide packages (via environment.systemPackages)
[group('quick-eval')]
syspkgs:
    @just --justfile {{justfile()}} _{{nixtype}}_check
    @echo -e "{{BOLD + BLUE}}Dotfiles system packages:{{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval "$(just --justfile {{justfile()}} _{{nixtype}}_system)" "environment.systemPackages"

# list out all user local packages (via home.packages)
[group('quick-eval')]
homepkgs:
    @just --justfile {{justfile()}} _{{nixtype}}_check
    @echo -e "{{BOLD + BLUE}}Dotfiles home-manager packages:{{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval "$(just --justfile {{justfile()}} _{{nixtype}}_home)" "home.packages"

# list out all user shell aliases and session variables (via home.shellAliases and home.sessionVariables)
[group('quick-eval')]
homesession:
    @just --justfile {{justfile()}} _{{nixtype}}_check
    @echo -e "{{BOLD + BLUE}}Dotfiles home-manager shell aliases:{{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval "$(just --justfile {{justfile()}} _{{nixtype}}_home)" "home.shellAliases"
    @echo -e "{{BOLD + BLUE}}Dotfiles home-manager session variables:{{NORMAL}}"
    source {{justfile_directory()/scripts-dir/eval-script}} && \
    nix_eval "$(just --justfile {{justfile()}} _{{nixtype}}_home)" "home.sessionVariables"
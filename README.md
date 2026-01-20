# Dotfiles: Home Manager Flake Setup

This repository defines a modular, multi-mode Home Manager setup using Nix flakes.
It supports:

- Multiple systems and multiple configurations
- Uses `options.*` for modularizing both home-manager modules and nixos modules
- Enables per-system overrides for home-manager setups, nixos archetypes
- Organized `*.d` fragments for shell hooks and modular configuration

## Getting Started

### Pre-Setup

- Install nixos/nixos-wsl/nixos-darwin
- OR Install nix with the multi-user installation

1. If on nixos/nixos-wsl will need to first setup `/etc/nixos/configuration.nix` with enabling experimental features. If on nix-darwin (or standalone nix) go into `/etc/nix/nix.conf` and enable experimental features.
2. Add the following packages to `/etc/nixos/configuration.nix` (optionally: `nix profile install` or `nix profile add`): `git`, and `gh`
3. Setup `gh` by using `gh auth login` then clone the dotfiles repo with `gh repo clone [repo_path]`
4. Using `nix develop` in the `dotfiles` root directory, will install `just` (task runner), `vim` (editor) into the shell session and `glow` (markdown previewer). (recommended)
5. Follow instructions for either option A or option B

### Option A (System configuration already in `dotfiles/nix/[arch]`)

1. Skip to final steps

### Option B (System configuration NOT in `dotfiles/nix/[arch]`)

1. in the `flake.nix` in `dotfiles/nix/[arch]`, add your system configuration into the `configurations` attribute set (choose username, systemname, stateversion, etc...)
2. Create a new directory in `dotfiles/nix/[arch]` with your chosen system name
3. Create a new directory in `dotfiles/home/[arch]` with your chosen system name
4. Create a blank `default.nix` in the newly created system-specific directories:

    ```[nix]
    { ... }:
    {
        imports = [
            # Add the below, if required ; see step 5
            # ./hardware-configuration.nix
        ];
    }    
    ```

5. If on nixos, copy the `/etc/nixos/hardware-configuration.nix` file into `dotfiles/nix/[arch]/[system_name]`

    1. Then edit the `default.nix` in `dotfiles/nix/[arch]/[system_name]` by adding `./hardware-configuration.nix` as an import

### Final Steps

1. You will need to setup the `.env` file in `dotfiles/` with the approriate environment variables selecting your system and nixtype
2. Then run `just build` (if you are on nix-darwin for the first time, run `just darwin_init` to download nix-darwin and install for the first time)
3. Enjoy!

#### Imperative package installs

- Use nix profile to imperatively install packages instead through home-manager config



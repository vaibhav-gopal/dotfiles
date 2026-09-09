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



## Homebrew (nix-darwin only)

Homebrew covers what nix does poorly on macOS: GUI applications and Mac App Store
apps. CLI tooling still belongs in home-manager — see section 8 of `LEARN.md` for
the full decision order.

Managed by `modules.homebrew` in `nix/nix-darwin/modules/homebrew/default.nix`.

### One-time setup

nix-darwin manages Homebrew's *contents*, but does not install Homebrew itself.
Bootstrap it once:

```bash
just brew-bootstrap
```

That installs Homebrew if missing, then adopts any declared cask whose app is
already installed by hand (see *Migrating* below). It is idempotent - safe to
re-run. Then `just build`.

Until Homebrew exists, activation prints a red
`error: Homebrew is not installed, skipping...` and carries on harmlessly.

Related recipes:

| Recipe | Does |
|---|---|
| `just brew-bootstrap` | Install Homebrew, then adopt already-installed casks |
| `just brew-adopt` | Adoption pass on its own, without reinstalling anything |
| `just brew-check` | Report drift read-only, without changing anything |
| `just brewfile` | Print the declared Brewfile (works before any build) |

`brew-check` is worth an occasional run because `just build` cannot fix either
kind of drift it reports. `brew bundle` trusts Homebrew's receipts: a cask whose
app you deleted still has a receipt, so the rebuild skips it rather than putting
it back, and an app installed by hand has no receipt to skip on. Anything marked
`DRIFT` is fixed by `just brew-adopt`.

The logic lives in `nix/scripts/homebrew.sh`. It evaluates the Brewfile from the
config rather than reading it out of the nix store, so it works before the first
build - which is exactly when bootstrapping happens.

### Usage

Declare everything in your host's darwin config (e.g. `nix/nix-darwin/vgmacbook/`):

```nix
modules.homebrew = {
  casks = [ "firefox" "spotify" ];       # GUI apps
  brews = [ ];                            # CLI formulae - prefer nix instead
  masApps = { "Pages" = 409201541; };     # Mac App Store, by numeric ID
  taps = [ ];                             # extra formula repositories
};
```

Then `just build`. Never `brew install` directly — see the guardrail below.

Find cask tokens with `brew search <name>`, and confirm what a token actually
installs with `brew info --cask <token>`.

### masApps

App Store apps cannot be casks, so anything App-Store-exclusive (Apple's own
apps, Safari extensions) goes here, keyed by numeric ID. Get the IDs for what is
already installed with:

```bash
nix run nixpkgs#mas -- list
```

`mas` itself needs no declaring — the nix-darwin module puts it on `PATH` during
activation. Caveats: you must be signed into the App Store, and `mas` can only
install apps already associated with that Apple ID.

Unlike casks, **already-installed App Store apps need no uninstall first** —
`brew bundle` checks the installed list and skips them, so declaring them just
records what is already there. The cleanup guardrail covers formulae, casks and
taps only; it does not uninstall App Store apps.

### The cleanup guardrail

`modules.homebrew.cleanup` defaults to `"zap"`. On every rebuild, any Homebrew
package **not** declared in the config is uninstalled, and for casks all
associated preference and application-support files are deleted too.

This makes the config the single source of truth, with two consequences:

- `brew install foo` is temporary — it will be reverted on the next rebuild.
  Add it to the config instead.
- It only touches things **Homebrew** installed. Apps installed manually by
  dragging a `.dmg` are invisible to brew and are left alone.

Set `cleanup = "uninstall"` to remove packages but keep their settings, or
`"none"` to disable the guardrail entirely.

### Migrating an already-installed app to a cask

Homebrew refuses to install a cask over an existing `.app` it did not install
(`It seems there is already an App at ...`). Two ways through it:

**Adopt (preferred).** Takes the existing app over in place, no re-download:

```bash
brew install --cask --adopt <token>
```

Do this once per already-installed app, before the first `just build` that
declares it. Adoption expects the installed version to match the cask's; on a
mismatch, update the app first or fall back to replacing it.

**Replace.** Move the app to the Trash, then declare the cask and rebuild.
Always works, but re-downloads the app and loses anything stored inside the
bundle.

Either way, once the app is brew-managed, later rebuilds are a no-op for it.
Migrate in small batches so a failure is easy to attribute.

### Aliases

| Alias | Does |
|---|---|
| `bcheck` | Is the system in sync with what's declared? |
| `bdrift` | Dry run: what's installed but NOT declared |
| `bls` | Everything currently installed |
| `bout` | What's outdated (incl. auto-updating casks) |
| `bup` | Deliberate `update && upgrade` |
| `bclean` | Manual `cleanup --prune=all` + `autoremove` |
| `bdoc` | `brew doctor` health check |
| `bfile` | View the generated Brewfile |

Defined in `home/nix-darwin/modules/homebrew`, not the system module - they are
home-manager `home.shellAliases` like every other alias in the repo, toggled
with `nixtype.homebrew.enable`. Inspect the merged set with:

```bash
just evalhomeconfigs home.shellAliases
```

### Background agents

Two launchd agents, both toggleable and rescheduleable via
`modules.homebrew.{cleanupAgent,updateAgent}`:

- `brew-cleanup` — Sundays 03:00, `cleanup --prune=all` + `autoremove`
- `brew-update` — daily 09:00, `brew update` only (metadata; never upgrades)

Both log to `~/Library/Logs/brew-{cleanup,update}.log`. Rebuilds never upgrade
anything, by design — upgrading is manual, via `bup`.

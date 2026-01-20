# NixOS & Flakes: Knowledge Base

## Reading

### Language, Nixpkgs and Flakes

[NIX LANG BUILTINS](https://nix.dev/manual/nix/2.25/language/builtins)

[NIX LANG BASICS](https://nix.dev/tutorials/nix-language)

[NIXPKGS MANUAL](https://nixos.org/manual/nixpkgs/stable/)

[NIXPKGS STDENV CHAPTER](https://nixos.org/manual/nixpkgs/stable/#chap-stdenv)

[NIXPKGS OVERRIDES & OVERLAYS](https://nixos.org/manual/nixpkgs/stable/#chap-overrides)

[NIXPKGS LIB FUNCTIONS REFERENCE](https://nixos.org/manual/nixpkgs/stable/#chap-functions)

[NIX FLAKE GUIDE](https://nixos-and-flakes.thiscute.world)

### Nixos + Home-Manager

[NIXOS MANUAL](https://nixos.org/manual/nixos/stable/)

[NIXOS OPTIONS SEARCH](https://search.nixos.org/options)

[NIXOS PACKAGES SEARCH](https://search.nixos.org/packages)

[NIXOS WIKI](https://wiki.nixos.org/)

[HOME-MANAGER BASICS](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nix-darwin-module)

[HOME-MANAGER OPTIONS](https://nix-community.github.io/home-manager/options.xhtml)

[HOME-MANAGER NIXOS MODULE OPTIONS](https://nix-community.github.io/home-manager/nixos-options.xhtml)

[HOME-MANAGER NIX-DARWIN MODULE OPTIONS](https://nix-community.github.io/home-manager/nix-darwin-options.xhtml)

[NIX-DARWIN STARTER](https://github.com/nix-darwin/nix-darwin)

[NIX-DARWIN OPTIONS](https://nix-darwin.github.io/nix-darwin/manual/index.html)

## 1. Quick Tips & Gotchas

### Paths: Quoted vs. Raw
Nix treats file paths very strictly based on syntax.
* **Raw Paths (`./my-file`):** Evaluated **immediately**. The file or directory is copied into the Nix Store *at evaluation time*. The variable in your code becomes a path to the store location (e.g., `/nix/store/abc...-my-file`).
* **String/Quoted Paths (`"./my-file"`):** Treated as **literal strings**. They are *not* copied to the store.
    * *Warning:* Using a string path usually fails if a Nix function expects a file object, but it is required for symlinking to absolute paths outside the store.

### Accelerating Dotfiles (Home Manager)
Normally, Home Manager copies your config files into the Nix Store and symlinks from there. This means every tiny edit requires a rebuild (`home-manager switch`) to copy the new version to the store.
* **The Fix:** Use `config.lib.file.mkOutOfStoreSymlink`.
* **How it works:** Creates a symlink pointing directly to the *original* file on your disk, skipping the Nix Store copy completely.
* **Requirement 1:** You **must** pass the path as a string.
* **Requirement 2:** It **must** be an absolute path (e.g., `"${config.home.homeDirectory}/.dotfiles/zsh/.zshrc"`).
* **Benefit:** Edits take effect immediately. No rebuild needed.

### Git & Flakes
* **The Golden Rule:** Flakes are "hermetic." They can only see files that are **tracked by git**.
* **Common Error:** If you create a new file `modules/new-feature.nix` but forget to `git add` it, Nix will throw a "file not found" error, even though you can see the file right there in your terminal.

---

## 2. Nix Modules (The Building Blocks)

A **Module** is simply a function that accepts specific inputs and returns a specific structure. It is the unit of composition for NixOS, Home Manager, and Darwin.

### The "Magic" Inputs (Function Arguments)
When you write `{ config, pkgs, ... }:`, these arguments are injected automatically by the module system evaluator.

| Argument | Source | Description |
| :--- | :--- | :--- |
| **`config`** | System | The final, fully merged configuration of the entire system. Used to check values set by *other* modules (e.g., `if config.services.xserver.enable...`). |
| **`pkgs`** | System | The specific instance of Nixpkgs for this system. It is locked to the architecture (`x86_64-linux`) and version defined in your flake. |
| **`lib`** | System | The standard library (`nixpkgs.lib`). Contains essential helpers like `mkIf`, `mkMerge`, `mkOption`, and `types`. |
| **`modulesPath`** | NixOS | Path to the built-in modules folder. Useful for importing generic profiles (e.g., `"${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"`). |
| **`osConfig`** | Home Manager | **Only available when HM is a NixOS module.** Gives user modules read-only access to the system-level configuration. |
| **`specialArgs`** | **User Defined** | Custom arguments you pass via `flake.nix`. This is how you inject `inputs`, `self`, or your custom `usrLib`. |

### The 3 Core Outputs
A module returns an Attribute Set containing these three keys.

1.  **`options`**
    * **Purpose:** Defines the "API" or schema.
    * **Usage:** Use `lib.mkOption` to define the type (`types.bool`, `types.str`), description, and default values.
    * *Analogy:* The "Interface" in OOP.

2.  **`config`**
    * **Purpose:** Sets values for options defined in `options` (either your own or upstream ones).
    * **Usage:** Where the actual logic happens.
    * *Implicit Behavior:* If a module returns a set without `options`, `config`, or `imports` at the top level, Nix assumes the **entire set** is the `config`. This is known as the "shorthand" syntax.

3.  **`imports`**
    * **Purpose:** Composes other modules into the system.
    * **Usage:** A list of paths (`./hardware.nix`) or variables (`inputs.home-manager.nixosModules.home-manager`).

---

## 3. Nix Flakes (The Entry Point)

A **Flake** is a project structure that ensures reproducibility by pinning dependencies in a `flake.lock` file.

### Inputs (Sources)
Defined in the `inputs` attribute. These are **static** (fetched before any code is evaluated).
* **`url`:** The source location (e.g., `github:nixos/nixpkgs/nixos-unstable`).
* **`follows`:** A mechanism to de-duplicate dependencies. (e.g., forcing `home-manager` to use *your* version of `nixpkgs` instead of downloading its own copy).

### Outputs (The Product)
Defined as a function: `outputs = { self, nixpkgs, ... }: { ... }`.
The Nix CLI looks for specific "Standard Attributes" in the returned set.

#### Reserved / Standard Output Attributes

| Attribute Name | Description | CLI Command |
| :--- | :--- | :--- |
| **`nixosConfigurations`** | Defines a full NixOS system. | `nixos-rebuild switch --flake .#hostname` |
| **`homeConfigurations`** | Defines a standalone Home Manager user profile. | `home-manager switch --flake .#user@host` |
| **`darwinConfigurations`** | Defines a macOS system (requires `nix-darwin`). | `darwin-rebuild switch --flake .#hostname` |
| **`devShells`** | Development environments (compiler tools, LSPs). | `nix develop` |
| **`packages`** | Custom packages built by this flake. | `nix build` |
| **`apps`** | Runnable programs exposed by the flake. | `nix run` |
| **`nixosModules`** | Reusable modules to be shared with others. | Used via `imports` in other flakes. |
| **`overlays`** | Functions to modify/extend `pkgs`. | Used in `nixpkgs.overlays`. |
| **`templates`** | Scaffolding for new projects. | `nix flake init -t ...` |
| **`formatter`** | The command to run when formatting code. | `nix fmt` |

### Bridging Flakes & Modules
Flake inputs (like `nixpkgs`, `self`, `inputs`) are **not** automatically available inside your Modules. You must bridge them manually.

* **`specialArgs`**: Passes data from `flake.nix` → `nixosConfigurations` modules.
* **`extraSpecialArgs`**: Passes data from `flake.nix` → `homeConfigurations` modules.

## 4. Advanced Module Args (_module.args)
While `specialArgs` injects data from the outside (flake level), `_module.args` allows modules to inject data from the inside (module level).

`_module.args`

* **What it is**: A special option that allows a module to define arguments that become available to all other modules in the same system configuration.
* **How it works**: It uses the module system's lazy evaluation "fixpoint." Nix scans all modules for _module.args definitions first, aggregates them, and then passes the result back into the modules as function arguments.
* **Common Use Case**: Creating a custom library (usrLib) or helper set that every file in your config can use without needing to import it manually every time.

```nix
# modules/common.nix
{ lib, ... }: {
  # Now every other module in this system can use { usr, ... }: ...
  _module.args.usr = import ../lib { inherit lib; };
}
```

`_module.check` & `_module.freeformType`

* **`_module.check`**: (Boolean) Defaults to `true`. If set to `false`, NixOS won't check if all options defined in your config actually exist. *Use with caution—usually for debugging.*

* **`_module.freeformType`**: Allows a module to accept settings that aren't strictly defined in `options`. This is how settings like `users.users.<name>.openssh.authorizedKeys.keys` work without needing an option for every possible string.

## 5. The "Package-Functions" (Pkgs as Libraries)

These are functions found inside `pkgs` that act like *infrastructure tools* rather than installable software. They are essential for building custom artifacts.

### `pkgs.callPackage`

The *MVP* of Nix. The standard way to import and call a package derivation.

**Magic Feature: Dependency Injection.** If your file `my-hello.nix` is `{ stdenv, fetchurl }: ...`, calling `pkgs.callPackage ./my-hello.nix {}` automatically finds `stdenv` and `fetchurl` in `pkgs` and passes them in.

**Usage:** Always use this instead of `import` for packages.

### `pkgs.stdenv`

The ***Standard Environment***. This is the foundation of the Nix packaging ecosystem and contains the basic tools needed to build software on Unix systems.

### What's Inside stdenv?

- **Compiler toolchain:** GCC or Clang (depending on platform)
- **Build tools:** GNU Make, CMake support, pkg-config
- **Core utilities:** Coreutils (ls, cp, mv, etc.), findutils, diffutils
- **Text processing:** sed, awk, grep
- **Patching tools:** patch, patchelf (for fixing binary dependencies)
- **Shell:** Bash

#### `stdenv.mkDerivation`

The *fundamental building block* of almost all packages in Nixpkgs. This function takes an attribute set describing how to build a package and returns a ***derivation***.

**Basic structure:**
```nix
stdenv.mkDerivation {
  pname = "hello";
  version = "2.10";
  
  src = fetchurl {
    url = "mirror://gnu/hello/hello-2.10.tar.gz";
    sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
  };
  
  # Build phases run automatically:
  # unpackPhase, patchPhase, configurePhase, buildPhase, 
  # checkPhase, installPhase, fixupPhase
}
```

#### Build Phases

`stdenv.mkDerivation` runs through several phases automatically:

1. **unpackPhase:** Extracts source archives
2. **patchPhase:** Applies patches
3. **configurePhase:** Runs `./configure` if present
4. **buildPhase:** Runs `make` by default
5. **checkPhase:** Runs `make check` (if `doCheck = true`)
6. **installPhase:** Runs `make install`
7. **fixupPhase:** Fixes up binaries, strips them, etc.

You can override any phase or add hooks:
```nix
stdenv.mkDerivation {
  # ...
  preConfigure = ''
    substituteInPlace Makefile --replace /usr/bin $out/bin
  '';
  
  postInstall = ''
    wrapProgram $out/bin/myapp --prefix PATH : ${lib.makeBinPath [ dep1 dep2 ]}
  '';
}
```

### `pkgs.writeShellScriptBin`

***Quick Scripts***. Creates a package containing a single executable script inside `/bin`.

**Usage:** `pkgs.writeShellScriptBin "my-echo" "echo 'Hello World!'"`

**Result:** A package you can add to `environment.systemPackages` that provides the `my-echo` command.

### `pkgs.substituteAll`

The ***Patcher***. Replaces placeholders (`@var@`) in a file with actual Nix store paths.

**Usage:** Essential for hardcoding paths in config files so they refer to the correct dependencies (e.g., replacing `@python@` with `/nix/store/.../bin/python`).

### `pkgs.runCommand`

The ***Generic Builder***. Lets you run arbitrary shell commands to produce a file or directory.

**Usage:** "I just want to run mkdir, cp, and sed and have the result be a package."

```nix
pkgs.runCommand "my-dir" {} ''
  mkdir -p $out/conf
  cp ${configFile} $out/conf/generated.conf
''
```

### `pkgs.fetchurl`

The ***HTTP/FTP Downloader***. Fetches files from URLs. Requires a hash (sha256) to ensure purity.

```nix
fetchurl {
  url = "https://example.com/file.tar.gz";
  sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
}
```

### `pkgs.fetchgit`

The ***Git Fetcher***. Clones a git repository at a specific revision.

```nix
fetchgit {
  url = "https://github.com/user/repo.git";
  rev = "abc123...";
  sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
}
```

**Note:** For GitHub specifically, there's also `fetchFromGitHub` which is more convenient, but `fetchgit` works for any git repository.

---

## 6. Overrides & Overlays

Ways to modify packages without forking Nixpkgs.

### The Overlay (final: prev:)

An ***overlay*** is a function that accepts `final` (state after all overlays) and `prev` (state before this overlay) and returns a set of new/modified packages.

**Usage:** *Global modification*. Applies to every package in the system that depends on the library you change.

```nix
final: prev: {
  # Example: Override 'hello' globally
  hello = prev.hello.overrideAttrs (old: {
    src = ...; # new source
  });
}
```

### `pkg.override` (Arguments)

**What it does:** Changes the *inputs* (arguments) of a package function.

**Use Case:** "I want to enable a compile-time feature."

**Example:** `firefox.override { enableWayland = true; }`

### `pkg.overrideAttrs` (Steps)

**What it does:** Changes the *derivation attributes* (steps passed to `stdenv.mkDerivation`).

**Use Case:** "I want to add a patch, change the version, or add a postInstall command."

**Example:**
```nix
hello.overrideAttrs (oldAttrs: {
  pname = "hello-patched";
  postInstall = "rm $out/bin/bad-file";
})
```

#### Adding Metadata with `overrideAttrs`

You can also use `overrideAttrs` to add important metadata:

##### meta attributes

***Standard metadata*** that appears in package searches and provides documentation:

```nix
hello.overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    description = "A program that produces a familiar, friendly greeting";
    homepage = "https://www.gnu.org/software/hello/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.yourname ];
    platforms = lib.platforms.unix;
    mainProgram = "hello";  # The primary executable (for nix run)
  };
})
```

**Important `meta` fields:**
- **mainProgram:** Tells `nix run` which binary to execute (*essential* for packages with multiple binaries)
- **description:** Short one-line description
- **license:** Use values from `lib.licenses.*`
- **platforms:** Which systems can build this (e.g., `lib.platforms.linux`)

##### `passthru` for tests and checks

`passthru` allows you to attach arbitrary attributes to a derivation that don't affect the build but are useful for testing and downstream packages:

```nix
hello.overrideAttrs (oldAttrs: {
  passthru = {
    tests = {
      simple-test = runCommand "test-hello" {} ''
        ${hello}/bin/hello | grep -q "Hello"
        touch $out
      '';
    };
    
    updateScript = ./update.sh;
  };
})
```

**Common `passthru` uses:**
- **tests:** Derivations that test the package functionality
- **updateScript:** Script to check for new versions
- **Exposing internal dependencies:** Making build-time dependencies available to other packages

### `pkg.overrideScope`

**What it does:** Used for "package sets" (like `python3Packages` or `qtPackages`) to ensure internal consistency.

**Why use it?** If you just use `override` on a Python package, other Python packages might still link against the old one. `overrideScope` forces the entire set to re-evaluate using your new version.

---

## 7. Essential Builtins & Lib Functions

**`builtins`** are C++ functions (*fast, basic*), while **`lib`** is the Nixpkgs standard library (*rich, complex*).

### A. Grouped Builtins (Parsers & Types)

#### Serialization Parsers

- `builtins.fromJSON` / `builtins.toJSON`
- `builtins.fromTOML`
- `builtins.toXML` (Note: No `fromXML` exists natively yet)

**Goal:** Read config files directly into Nix variables to generate other configs.

#### Type Checkers

`builtins.isList`, `builtins.isAttrs`, `builtins.isString`, `builtins.isInt`, `builtins.isBool`, `builtins.isFunction`

**Goal:** Writing robust functions that handle different input types.

### B. List Manipulation (lib.lists)

#### Filtering & Searching

- `builtins.filter` / `lib.filter`: Keeps elements where the predicate is true
- `builtins.elem` / `lib.elem`: Checks if a value exists in the list (boolean)
- `lib.any` / `lib.all`: Returns true if any or all elements match a condition

#### Transformation

- `builtins.map`: The classic. `map (x: x+1) [1 2]`
- `builtins.foldl'`: Reduce a list to a single value (strict left fold)
- `lib.unique`: Removes duplicates
- `lib.flatten`: Turns `[[1] [2]]` into `[1 2]`

#### Conditionals

- `lib.optional`: Returns `[ x ]` if true, `[]` if false
- `lib.optionals`: Returns `[ x y ]` if true, `[]` if false

**Goal:** Building lists of packages without messy if/else blocks.

### C. Attribute Set Manipulation (lib.attrsets)

#### Mapping

- `lib.mapAttrs`: Modify values. `(name: value: value + 1)`
- `lib.mapAttrs'` (Prime): Modify keys and values
- `lib.mapAttrsToList`: Iterates over the set and returns a list. Great for converting `{ port=80; host="loc"; }` into configuration lines

#### Set Operations

- `builtins.attrNames`: Returns a list of keys
- `builtins.attrValues`: Returns a list of values
- `lib.filterAttrs`: Removes attributes based on a `name: value` predicate
- `lib.recursiveUpdate`: Deeply merges two sets (unlike `//` which only merges the top layer)

### Creation

- `builtins.listToAttrs`: Converts `[{name="a"; value=1;}]` into `{a=1;}`
- `lib.genAttrs`: Creates a set from a list of names. `genAttrs ["a" "b"] (name: name + "_val")` → `{ a="a_val"; b="b_val"; }`

#### Creation

### D. Module Helpers (lib.modules)

- `lib.mkIf`: Applies content only if the condition is true
- `lib.mkMerge`: Merges a list of attribute sets. Allows multiple `mkIf` blocks for the same option
- `lib.mkForce`: Overrides all other definitions of an option
- `lib.mkDefault`: Sets a value with low priority (can be overridden easily)

### E. Debugging

- `builtins.trace`: Prints to stderr, returns the second argument
  - `builtins.trace "Checking value..." x`
- `lib.traceVal`: Prints the value and returns it
- `lib.traceSeq`: Deeply prints a complex structure (like a nested set) which normal trace might hide as `<CODE>`
# TODO LIST

## DONE
- zsh and bash (rc, env and profile) setup - DONE
- cargo, conda, nvm (or bun), java (temurin) - DONE
- c/c++ --> gcc, cmake, make, gdb, etc...- DONE
- more CLI tools (markdown previewer, set default pager to bat) - DONE
- rewrite with support for nix-darwin and nixos - DONE
- remove home-manager config fat - DONE
- add taskfiles to automate setup and processes - DONE
- create a taskfile which holding helpful nix / dotfiles functions, which is symlinked to the home directory so you can access via `task --global [taskname]` (or symlink the existing proj root Taskfile and add more functions to it) - DONE
- setup nixos w/ wsl2 - DONE
- create a `pkgs.mkShell` flake template for future projects (usable with `nix develop`) - DONE
- setup nix-direnv and direnv - DONE
- set up a nixpkgs-unstable or nixos-unstable input to the flakes, to allow mix-n-match certain packages to be up-to-date vs LTS (update go-task, its creating phantom directories randomly) - DONE

## NEED TO DO
- change dotfiles config files to use `mkOutOfStoreSymlink` (HIGH) - IN PROGRESS
- nixos server setup (not with hyprland or any GUI) (HIGH) - IN PROGRESS
- zellij keyboard shortcut setup (MEDIUM)
- vim setup + nvim setup (MEDIUM)
- upgrade the nix templates init to also replace the system and nixpkgs-version/url dynamically from a predefined list via `arch` command or from the current nix generation (need to figure out how to do this) (LOW) - IN PROGRESS

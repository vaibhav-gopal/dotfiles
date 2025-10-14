# TODO LIST

## DONE
- zsh and bash (rc, env and profile) setup - DONE
- cargo, conda, nvm (or bun), java (temurin) - DONE
- c/c++ --> gcc, cmake, make, gdb, etc...- DONE
- more CLI tools (markdown previewer, set default pager to bat) - DONE
- rewrite with support for nix-darwin and nixos - DONE
- remove home-manager config fat - DONE
- add taskfiles to automate setup and processes - DONE

## NEED TO DO
- zellij keyboard shortcut setup
- vim setup + nvim setup
- setup nixos w/ wsl2
- create a `pkgs.buildEnv` flake (for reproducible `nix profile add` for home) (like a requirements.txt for imperatively installed packages for the current user)
- create a `pkgs.mkShell` flake template for future projects (usable with `nix develop`)
- create a taskfile which holding helpful nix / dotfiles functions, which is symlinked to the home directory so you can access via `task --global [taskname]` (or symlink the existing proj root Taskfile and add more functions to it)
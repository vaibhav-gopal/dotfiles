# NixOS - WSL

This is actually a custom version of nixos for wsl...
please (I mean it) see [this documentation](https://nix-community.github.io/NixOS-WSL/how-to/vscode.html)

From there you can learn to setup the following:
- install nixos-wsl and use
- update the nix-channels and rebuild the system for the first time
- Change the username (safely)
- Setting up the nix flake
- setting up the vscode remote, for easier configuration setup

You will also likely have to first:
- add the experimental features for nix-command and flakes to the configuration.nix file in /etc/nixos (you can leave it there even when the flake is setup)
- nix profile install: gh, git, vim, go-task
- download the dotfiles repo and rebuild with the flake instead (ensure config is correct first) (also stop then start wsl instance for hostname changes to take effect w/ `wsl -t NixOS` and `wsl -d NixOS`)
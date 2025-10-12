# None (a.k.a. base home-manager + nix setup)

## nix.conf setup

This directory will store all nix.conf and configuration.nix files (if using nix-darwin or nixos)

### nix.conf location / symlinking process

nix looks for nix.conf in the following locations, in the following order (duplicate values are overridden, therefore user space nix.conf takes precedence):

1. `/etc/nix/nix.conf` or `$NIX_CONF_DIR/nix.conf` if set

2. Otherwise, if `$NIX_USER_CONF_FILES` is set, then each path seperated by `:` is loaded in reverse order

3. Otherwise, `$XDG_CONFIG_DIRS/nix/nix.conf` or `$XDG_CONFIG_HOME/nix/nix.conf` if either are set, defaults are `$XDG_CONFIG_DIRS=/etc/xdg` and `$XDG_CONFIG_HOME=$HOME/.config`

### configuration.nix (for nix-darwin or nixos)

[TODO] need more research, but will probably have to symlink to the proper directory
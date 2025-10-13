# None (a.k.a. base home-manager + nix setup)

## Making a new configuration

1. Create a new folder with hostname
2. copy flake.template.nix into folder
3. configure flake.nix with correct hostname, username, home directory, version (and flake inputs versions)
4. ensure nix-channel has the correct nixpkgs version as well : see nix-darwin taskfile for more info
5. make a new taskfile in the folder (configure build step ; see home-manager docs for more info) : see nix-darwin taskfile for more info
6. yippee

## nix.conf setup

Use nix-base root taskfile with the `link` and `clean` tasks

### nix.conf location / symlinking process

nix looks for nix.conf in the following locations, in the following order (duplicate values are overridden, therefore user space nix.conf takes precedence):

1. `/etc/nix/nix.conf` or `$NIX_CONF_DIR/nix.conf` if set

2. Otherwise, if `$NIX_USER_CONF_FILES` is set, then each path seperated by `:` is loaded in reverse order

3. Otherwise, `$XDG_CONFIG_DIRS/nix/nix.conf` or `$XDG_CONFIG_HOME/nix/nix.conf` if either are set, defaults are `$XDG_CONFIG_DIRS=/etc/xdg` and `$XDG_CONFIG_HOME=$HOME/.config`
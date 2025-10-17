{ pkgs, pkgs-unstable, config, lib, ... }:
{
  nixpkgs.overlays = [
    # Overlay: Use `self` and `super` to express the ineritance relationship
    # override some derivation build inputs or default attributes ; every package has a unique set in addition to some default attributes
    # then, if the build input changes ; the packages internals are changed, for all packages and the whole system IF it is installed as a package

    # E.g. changing chosen git version for the whole system ; including other packages which include it
    (self: super: {
      git = pkgs-unstable.git;
    })

    # E.g. changing chosen git build inputs
    (self: super: {
      git = super.git.override {
        # insert some git derivation build inputs overrides...
      };
    })
  ];
}
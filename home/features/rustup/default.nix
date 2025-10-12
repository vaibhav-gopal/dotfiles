{ config, pkgs, ... }:

{
  # originally installed cargo and rustc, but only single version available
  # instead now installed rustup, which can then install its own rust toolchain verions
  home.packages = [
    pkgs.rustup
  ];

  # other solution is to use a rust overlay (see fenix) (modifies the nixpkgs repo ; adds packages like all rust toolchain versions)
  # can use with nix-shells for per-project rust toolchain installation, config and reproducibility (sandbox)
  # NOTE: not really that much easier ; must set up shell.nix flake for every project ; GG disk space ; GG project setup time ; but can easily transfer to other machines (that should have nix installed and setup) ; idk...

  # Optional: Set environment variables used by cargo and rustup
  home.sessionVariables = {
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";
    RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
  };
}
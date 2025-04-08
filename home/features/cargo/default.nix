{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.cargo
    pkgs.rustc
  ];

  # Optional: Set environment variables used by cargo
  home.sessionVariables = {
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";
    RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
  };
}


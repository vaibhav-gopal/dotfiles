{ ... }:
{
  imports = [
    # Base configuration
    ./base.nix

    # Features
    ./bun
    ./cpp
    ./editor
    ./git
    ./glow
    ./java
    ./rustup
    ./shell
    ./ssh
    ./term
  ];
}

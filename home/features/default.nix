{ ... }:
{
  imports = [
    # Base configuration
    ./base.nix

    # Features
    ./bun
    ./cpp
    ./git
    ./glow
    ./java
    ./rustup
    ./shell
    ./ssh
    ./term
    ./uv
    ./vim
  ];
}

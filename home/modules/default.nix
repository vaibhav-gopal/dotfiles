{ ... }:
{
  imports = [
    # Core configuration
    ./core.nix

    # Features
    ./bun
    ./editor
    ./git
    ./java
    ./rustup
    ./shell
    ./ssh
    ./term
  ];
}

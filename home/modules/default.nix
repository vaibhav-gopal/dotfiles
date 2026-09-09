{ ... }:
{
  imports = [
    # Core configuration
    ./core.nix

    # Features
    ./bun
    ./claude-code
    ./editor
    ./git
    ./java
    ./rustup
    ./shell
    ./ssh
    ./term
  ];
}

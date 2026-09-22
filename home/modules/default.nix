{ ... }:
{
  imports = [
    # Core configuration
    ./core.nix

    # Features
    ./bun
    ./claude-code
    ./editor
    ./freerdp
    ./git
    ./java
    ./rustup
    ./shell
    ./ssh
    ./term
  ];
}

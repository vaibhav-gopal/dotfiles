{ ... }:
{
  imports = [
    ./nixos.nix
    ./features/env.nix
    ./features/home.nix
    ./features/nix.nix
  ];
}
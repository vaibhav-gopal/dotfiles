# SEE https://nixos-and-flakes.thiscute.world/development/intro
# Can install this flake as a package (to: `environment.systemPackages` or `home.packages`, via an entry like: `(import [INSERT PATH TO THIS FILE])`

{ pkgs, ... }:
let
  # List required packages here
  packages = with pkgs; [

  ];
in pkgs.runCommand "[TEMPLATE-NAME]" 
{
  # Dependencies that should exist in the runtime environment
  buildInputs = packages;
  # Dependencies that should only exist in the build environment
  nativeBuildInputs = [ pkgs.makeWrapper ];
}
# Actual function/script to run
''
  echo "Hello Env Function!"
''
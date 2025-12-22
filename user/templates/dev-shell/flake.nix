# SEE https://nixos-and-flakes.thiscute.world/development/intro
{
  description = "A general dev shell template (for use with `nix develop`) ";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # change nixpkgs version if needed
  };

  outputs = { self , nixpkgs ,... }: let
    systems = ["x86_64-linux" "aarch64-darwin"];
  in {
    devShells = nixpkgs.lib.genAttrs systems (system:
      let
        pkgs = import nixpkgs {inherit system;};
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            cowsay
          ];
          shellHook = ''
            cowsay "Hello dev-shell!"
          '';
        };
      }
    );
  };
}
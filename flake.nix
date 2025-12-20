{
  description = "Starter nix development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
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
            vim
            just
            cowsay
            glow
          ];
          shellHook = ''
            cowsay "Use cmd 'glow' to view README.md to get started!"
          '';
        };
      }
    );
  };
}
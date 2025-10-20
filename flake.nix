{
  description = "Starter nix development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = { self , nixpkgs ,... }: let
    systems = ["x86_64-linux" "aarch64-darwin"];
  in {
    devShells.default = nixpkgs.lib.genAttrs systems (system:
      let
        pkgs = import nixpkgs {inherit system;};
      in pkgs.mkShell {
        packages = with pkgs; [
          cowsay
        ];
        shellHook = ''

        '';
      }
    );
  };
}
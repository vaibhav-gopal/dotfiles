{
  description = "Starter environment for dotfiles";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = import nixpkgs { inherit system; };

        baseShell = pkgs.mkShell {
            packages = [
                pkgs.just
            ];
        };
    in {
        devShells.default = baseShell;
    }
  );
}

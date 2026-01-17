{
  description = "A personal theme builder";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [];
      };
        
      baseShell = pkgs.mkShell {
        packages = [
            
        ];
        shellHook = ''
            echo Started Dev Shell!
        '';
      };
    in {
      packages.default = ;

      devShells.default = baseShell;
    }
  );
}

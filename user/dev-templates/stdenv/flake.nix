{
  description = "A general development environment template";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-xx.xx";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = import nixpkgs { inherit system; };
        
        baseShell = pkgs.mkShell {
            packages = [
                
            ];
            shellHook = ''
                echo Started Dev Shell!
            '';
        };
    in {
        # PROJECT DERIVATIONS (nix build ...)
        packages = {
            # default = someDefaultDerivation;
            # "anotherBuildOutput" = someOtherDerivation;
            # ...
        };

        # DEV SHELLS (nix develop ...)
        devShells = {
            default = baseShell;
            debug = baseShell.overrideAttrs (oldAttrs: {
                packages = oldAttrs.packages ++ [
                    # more debug packages on top of baseShell (or just make new shell)
                ];
                shellHook = ''
                    echo Started Debug Shell!
                '';
            });
            # ...
        };
    }
  );
}

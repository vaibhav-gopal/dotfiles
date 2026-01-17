{
  description = "Adding FHS ; Virtualize a linux file system / sandbox so non-nix minded packages can run (when apps expect standard linux filesystem paths "/bin", "/etc", ...)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = import nixpkgs { inherit system; };

        # FHS environment ; simply builds a derivation
        fhs = pkgs.buildFHSEnv {
            name = "fhs-env";
            targetPkgs = pkgs: [ 
                pkgs.stdenv.cc.cc # installing the standard environment gcc (GNU C Compiler) tool to the sandbox
            ];
            runScript = "bash"; # script / command to run on startup
            # runScript = ./buildPackage.sh # e.g. build / wrap another application in the FHS environment (yes this is a local dev path ; it works)
        };
        
        baseShell = pkgs.mkShell {
            packages = [ 
                pkgs.cmake
            ];
            shellHook = ''
                export PATH="$PATH:${fhs}/bin"
                echo "Adding FHS environment from ${fhs}/bin to path"
                ${fhs}/bin/${fhs.name}
                echo Started Dev Shell! (With FHS environment)
            '';
        };
    in {
        packages.default = fhs.env;
        devShells.default = baseShell;
    }
  );
}

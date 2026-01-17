{
  description = "Adding FHS ; Virtualize a linux file system / sandbox so non-nix minded applications can run (when apps expect standard linux filesystem paths '/bin', '/etc', ...)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = import nixpkgs { inherit system; };

        # FHS environment ; simply builds a derivation
        # fhs = pkgs.buildFHSEnv {
        #     name = "fhs-env";
        #     targetPkgs = pkgs: [ 
        #         pkgs.stdenv.cc.cc # installing the standard environment gcc (GNU C Compiler) tool to the sandbox
        #     ];
        #     runScript = "bash"; # script / command to run on startup
        # };

        # FHS environment ; wrap an existing package
        fhs = pkgs.buildFHSEnv {
            name = "fhs-env";
            targetPkgs = pkgs: [ 
                pkgs.cowsay
            ];
            runScript = "cowsay";
            # runScript = ./buildPackage.sh # e.g. build / wrap another application in the FHS environment (yes this is a local dev path ; it works)
        };
        
        baseShell = pkgs.mkShell {
            packages = [ 
                pkgs.cmake
            ];
            shellHook = ''
                echo "Started Dev Shell!"
                export PATH="$PATH:${fhs}/bin"
                echo "Adding FHS environment from ${fhs}/bin to path ; Starting FHS Environment"
                ${fhs}/bin/${fhs.name}
            '';
        };
    in {
        packages.default = fhs; # nix build will build the FHS derivation ; i.e. will create the relevant /bin folders and the "fhs-env" binary (you can imagine how this could wrap a package)
        devShells.default = baseShell;
    }
  );
}

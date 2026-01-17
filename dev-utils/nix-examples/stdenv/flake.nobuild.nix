{
  description = "A standard environment derivation example ; For all packages included in the standard environment see here: https://ryantm.github.io/nixpkgs/stdenv/stdenv/#chap-stdenv";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = import nixpkgs { inherit system; };
        
        package = pkgs.stdenv.mkDerivation {
            pname = "somepackage"; # package name --> creates a nix package called "${pname}-${version}"
            version = "1.0.1"; # package version
            src = builtins.fetchurl {
                url = "http://example.org/${pname}-source-${version}.tar.bz2";
                hash = pkgs.lib.fakeSha256; # replace with actual on runtime
            };
            buildInputs = [ pkgs.ncurses pkgs.perl ]; # additional packages / libraries not in the standard environment
            # stdenv has an automatic builder that executes the unix build interface of `./configure; make; make install` sequence of commands
            # hook into the standard builder with these...
            buildPhase = ''
                gcc foo.c -o foo
            ''; 
            installPhase = ''
                mkdir -p $out/bin
                cp foo $out/bin
            '';
            # OR replace it completely with custom builder
            builder = ./builder.sh;
            # NOTE: you will want to `source $stdenv/setup` at the top of the builder, to load the standard environment variables, and packages
            # NOTE: you can still call the stdenv builder with the bash function/alias `genericBuild` (loaded automatically if you source the above)
        };
    in {
        packages.default = package;
    }
  );
}

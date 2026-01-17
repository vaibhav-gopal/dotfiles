{
  description = "A general development environment template";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = import nixpkgs {
            inherit system;
            overlays = [];
        };

        dockerImage = ;
    in {
        packages.default = dockerImage;
    }
  );
}

{
  # Possible ways to use:
  # 1. Set up as a derivation, can build with nix build (vs cargo build)
  # 2. Has dev shell, use `nix develop` to get toolchain in current shell (for init, testing, checking, etc...)
  # 3. Associated rust-toolchain.toml, can use `rustup toolchain install` for permanent user-wide installation
  description = "Nix Dev environment for dot cli tool";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Rust overlay
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Flake utils
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self , nixpkgs , fenix, flake-utils, ... }: flake-utils.lib.eachDefaultSystem ( system:
    let
      pkgs = import nixpkgs {inherit system;};
      toolchain = fenix.packages.${system}.fromToolchainFile { dir = ./.; sha256 = nixpkgs.lib.fakeSha256; };
      # toolchain = fenix.packages.${system}.minimal; # Minimal profile of nightly channel
      # toolchain = fenix.packages.${system}.minimal.withComponents ["rust-analyzer"]; # Minimal profile of nightly channel with extra components
      # toolchain = with fenix.packages.${system}; combine [ minimal.cargo minimal.rustc stable.rustfmt stable.clippy ]; # Mix of components
    in {
      packages.default = (pkgs.makeRustPlatform { cargo = toolchain.cargo; rustc = toolchain.rustc; }).buildRustPackage rec {
        pname = "dot";
        version = "0.1";
        src = pkgs.lib.cleanSource ./.;
        cargoLock.lockFile = ./Cargo.lock;
        buildInputs = with pkgs; [ ]; # Add system deps here
      };
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          toolchain
        ];
      };
    }
  );
}
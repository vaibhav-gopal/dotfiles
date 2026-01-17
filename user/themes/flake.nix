{
  description = "A personal theme builder";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, pyproject-nix, uv2nix, pyproject-build-systems, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [];
      };

      # load uv workspace
      workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

      # make uv overlay
      overlay = workspace.mkProjectOverlay {
        sourcePreference = "wheel";
      };

      editableOverlay = workspace.mkEditablePyprojectOverlay {
        root = "$REPO_ROOT";
      };

      pythonSet = let python = pkgs.python3; in 
        (
          pkgs.callPackage pyproject-nix.build.packages {
            inherit python;
          }
        ).overrideScope (
          pkgs.lib.composeManyExtensions [
            pyproject-build-systems.overlays.wheel
            overlay
          ]
        ).overrideScope editableOverlay;
        
      baseShell = pkgs.mkShell (
        let
          virtualenv = pythonSet.mkVirtualEnv "uv-dev-env" workspace.deps.all;
        in {
          env = {
            UV_NO_SYNC = "1";
            UV_PYTHON = pythonSet.python.interpreter;
            UV_PYTHON_DOWNLOADS = "never"; # don't let uv manage its own python interpreters, use nix instead
          };
          packages = [
            virtualenv
            pkgs.uv
          ];
          shellHook = ''
            unset PYTHONPATH
            export REPO_ROOT=$(git rev-parse --show-toplevel)
          ''; 
        }
      );
    in {
      packages.default = pythonSet.mkVirtualEnv "uv-env" workspace.deps.default;
      devShells.default = baseShell;
    }
  );
}
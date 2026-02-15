{
  description = "A template python project";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
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

      # make uv overlays
      overlay = workspace.mkPyprojectOverlay {
        sourcePreference = "wheel";
      };
      editableOverlay = workspace.mkEditablePyprojectOverlay {
        root = "$REPO_ROOT";
      };

      python = pkgs.lib.head (pyproject-nix.lib.util.filterPythonInterpreters {
        inherit (workspace) requires-python;
        inherit (pkgs) pythonInterpreters;
      });

      pythonSet = (
          pkgs.callPackage pyproject-nix.build.packages {
            inherit python;
          }
        ).overrideScope (
          pkgs.lib.composeManyExtensions [
            pyproject-build-systems.overlays.wheel
            overlay
            editableOverlay
          ]
        );
        
      baseShell = pkgs.mkShell (
        let
          virtualenv = pythonSet.mkVirtualEnv "uv-env" workspace.deps.all;
        in {
          env = {
            UV_NO_SYNC = "1"; # prevent uv from managing virtual environment, this is managed by uv2nix
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
      devShells.default = baseShell;
    }
  );
}
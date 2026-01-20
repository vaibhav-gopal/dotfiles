{
  description = "A personal theme builder";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

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
            editableOverlay
          ]
        );

      defaultVenv = pythonSet.mkVirtualEnv "uv-default-env" workspace.deps.default; 
      fullVenv = pythonSet.mkVirtualEnv "uv-full-env" workspace.deps.all; 

      defaultDerivation = defaultVenv.overrideAttrs (old: {
        passthru = pkgs.lib.recursiveUpdate (old.passthru or { }) // {
          inherit (pythonSet.testing.passthru) tests;
        };
        meta = (old.meta or { }) // {
          mainProgram = "";
        };
      });
      fullDerivation = fullVenv.overrideAttrs (old: {
        passthru = pkgs.lib.recursiveUpdate (old.passthru or { }) // {
          inherit (pythonSet.testing.passthru) tests;
        };
        meta = (old.meta or { }) // {
          mainProgram = "";
        };
      });
        
      baseShell = pkgs.mkShell (
        {
          env = {
            UV_NO_SYNC = "1"; # prevent uv from managing virtual environment, this is managed by uv2nix
            UV_PYTHON = pythonSet.python.interpreter;
            UV_PYTHON_DOWNLOADS = "never"; # don't let uv manage its own python interpreters, use nix instead
          };
          packages = [
            fullVenv
            pkgs.uv
          ];
          shellHook = ''
            unset PYTHONPATH
            export REPO_ROOT=$(git rev-parse --show-toplevel)
          ''; 
        }
      );
    in {
      packages = {
        default = defaultDerivation;
        full = fullDerivation;
      };
      devShells.default = baseShell;
    }
  );
}
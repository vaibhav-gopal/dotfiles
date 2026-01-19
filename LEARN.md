# NixOs Modules

Output,Description,CLI Command
packages,Final build artifacts/binaries.,nix build .#name
apps,Specific executables to run directly.,nix run .#name
devShells,Isolated development environments.,nix develop .#name
checks,CI/CD tests and code quality audits.,nix flake check
formatter,The auto-formatter for this repository.,nix fmt
bundlers,Logic to pack apps into Docker/AppImages.,nix bundle .#name
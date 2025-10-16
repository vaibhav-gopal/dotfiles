# SEE https://nixos-and-flakes.thiscute.world/development/intro
{
  description = "[EDIT DESCRIPTION HERE]"; # A general dev shell template (for use with `nix develop`)

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05"; # change nixpkgs version if needed
  };

  outputs = { self , nixpkgs ,... }: let
    system = "[ENTER SYSTEM ARCH HERE]";
  in {
    devShells."${system}".default = let
      pkgs = import nixpkgs { inherit system; };
    in pkgs.mkShell {
      # List packages below
      packages = with pkgs; [
      ];

      # Enter shell commands to execute on startup
      shellHook = ''
        echo "Hello dev-shell! [EDIT THE CORRESPONDING NIX DEV SHELL]"
      '';
    };
  };
}
# SEE https://nixos-and-flakes.thiscute.world/development/intro
{
  description = "A general nix dev command (for use with `nix run .#[COMMAND NAME]`) "; 
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/[TEMPLATE-NIXPKGS]";
  };

  outputs = { self , nixpkgs ,... }: let
    system = "[TEMPLATE-ARCH]";
  in {
    packages."${system}".dev = let
      pkgs = import nixpkgs { inherit system; };
      # List required packages below
      packages = with pkgs; [
      ];
    in pkgs.runCommand "[TEMPLATE-NAME]" {
      # Dependencies that should exist in the runtime environment
      buildInputs = packages;
      # Dependencies that should only exist in the build environment
      # - This is if you want to enter another shell or program while still having the dev packages in PATH
      # - Add this line to the top of the output shell commands:
      # - wrapProgram $out/bin/zsh --prefix PATH : ${pkgs.lib.makeBinPath packages}
      nativeBuildInputs = [ pkgs.makeWrapper ];
    } ''
      echo "Hello Command!"
    '';
  };
}
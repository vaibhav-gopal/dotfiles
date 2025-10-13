{ pkgs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # install base packages
  environment.systemPackages = with pkgs; [
    neovim
    git
    go-task # like make but simpler : https://taskfile.dev/docs/getting-started
  ];
  environment.variables.EDITOR = "vim";
}
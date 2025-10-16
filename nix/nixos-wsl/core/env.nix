{ pkgs, lib, ... }:
{
  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
  ];

  environment = {
    # install base packages
    systemPackages = with pkgs; [
      wget
      vim
      git
      go-task # like make but simpler : https://taskfile.dev/docs/getting-started
      nil # nix LSP
      direnv # for dev shells
    ];

    variables.EDITOR = lib.mkForce "vim";
    variables.PAGER = lib.mkForce "less";
    variables.LESS = lib.mkForce "-FR --mouse";
  };

  # enable running foreign binaries on NixOS (allows vscode server)
  programs.nix-ld.enable = true;
}
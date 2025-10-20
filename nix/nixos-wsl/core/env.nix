{ pkgs, pkgs-unstable, lib, ... }:
{
  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
  ];

  environment = {
    # import all system packages both stable and unstable
    # install stable packages ; static, small changes between versions, need stability
    # install unstable packages ; need the latest version (bug fixes or etc...)
    systemPackages = [
      pkgs.wget
      pkgs.vim
      pkgs.git
    ];
    
    variables.EDITOR = lib.mkForce "vim";
    variables.PAGER = lib.mkForce "less";
    variables.LESS = lib.mkForce "-FR --mouse";
  };

  # enable running foreign binaries on NixOS (allows vscode server)
  programs.nix-ld.enable = true;
}
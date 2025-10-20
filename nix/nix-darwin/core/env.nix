{ pkgs, lib, pkgs-unstable, ... }:
{
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

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      # nerdfonts
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.space-mono
    ];
  };
}
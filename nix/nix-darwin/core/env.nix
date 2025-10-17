{ pkgs, lib, pkgs-unstable, ... }:
{
  environment = {
    # import all system packages both stable and unstable
    systemPackages = let 
      # install base packages ; static, small changes between versions, need stability
      systemStable = with pkgs; [
        wget
        vim
        git
      ];
      # install base packages ; need the latest version (bug fixes or etc...)
      # note this does not change the version other packages use if using this package ; use overlays instead
      systemUnstable = with pkgs-unstable; [
        go-task # like make but simpler : https://taskfile.dev/docs/getting-started
        nil # nix LSP
      ];
    in systemStable ++ systemUnstable;

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
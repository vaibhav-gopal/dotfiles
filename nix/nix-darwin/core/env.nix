{ pkgs, lib, ... }:
{
  environment = {
    # install base packages
    systemPackages = with pkgs; [
      go-task # like make but simpler : https://taskfile.dev/docs/getting-started
      nil # nix LSP
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
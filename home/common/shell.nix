{ config, pkgs, lib, hmPaths, modeConfig, ... }:

{
  # Enable both Zsh and Bash declaratively
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  # Enable Home Manager to manage environment variables in shells
  home.shell.enableShellIntegration = true;

  # Shared aliases across all shells
  home.shellAliases = {
    ll = "ls -la";
    gs = "git status";
    gl = "git log --oneline --graph --decorate";
    hm = "home-manager";
    hms = "home-manager switch --flake $DOTFILES_DIR#$HM_MODE_NAME";
    hml = "home-manager generations";
  };

  # Set login shell to zsh if it isn't already
  home.activation.setZshAsLoginShell = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if command -v chsh >/dev/null 2>&1 && command -v getent >/dev/null 2>&1; then
      current_shell=$(getent passwd "$USER" | cut -d: -f7 || echo "")
      target_shell="${pkgs.zsh}/bin/zsh"
      if [ "$current_shell" != "$target_shell" ]; then
        echo "⚙️  Switching login shell to: $target_shell"
        chsh -s "$target_shell"
      fi
    else
      echo "⚠️  Could not change login shell (missing chsh or getent)"
    fi
  '';
}


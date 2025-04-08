{ config, pkgs, lib, hmPaths, modeConfig, ... }:

{
  # Enable both Zsh and Bash declaratively
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Main interactive shell (.zshrc)
    initExtra = ''
      for f in "${hmPaths.homeCommonDir}/config/zsh.d"/*.zshrc; do
        [ -r "$f" ] && source "$f"
      done
    '';

    # Login shell (.zprofile)
    profileExtra = ''
      for f in "${hmPaths.homeCommonDir}/config/zsh.d"/*.zprofile; do
        [ -r "$f" ] && source "$f"
      done
    '';

    # Always-loaded shell (.zshenv)
    envExtra = ''
      for f in "${hmPaths.homeCommonDir}/config/zsh.d"/*.zshenv; do
        [ -r "$f" ] && source "$f"
      done
    '';
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    initExtra = ''
      for f in "${hmPaths.homeCommonDir}/config/bash.d"/*.bashrc; do
        [ -r "$f" ] && source "$f"
      done
    '';

    profileExtra = ''
      for f in "${hmPaths.homeCommonDir}/config/bash.d"/*.profile; do
        [ -r "$f" ] && source "$f"
      done
    '';     
  };
  
  # Enable Home Manager to manage environment variables in shells
  # home.shell.enableShellIntegration = true;

  # Enable starship shell prompt
  programs.starship = {
    enable = true;
  };
  home.file.".config/starship.toml".source = hmPaths.homeCommonDir + "/config/starship.d/starship.toml";

  # Shared aliases across all shells
  home.shellAliases = {
    ll = "ls -la";
    lt = "eza -laT";
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


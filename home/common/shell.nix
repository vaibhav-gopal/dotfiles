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
      # Load shared/common Zsh rc snippets
      for f in "${hmPaths.homeCommonConfigsDir}/zsh.d/*.zshrc"(N); do
        [ -r "$f" ] && source "$f"
      done

      # Load mode-specific local Zsh rc snippets
      for f in "${modeConfig.modeConfigsPath}/zsh.d/*.zshrc"(N); do
        [ -r "$f" ] && source "$f"
      done
    '';

    # Login shell (.zprofile)
    profileExtra = ''
      for f in "${hmPaths.homeCommonConfigsDir}/zsh.d/*.zprofile"(N); do
        [ -r "$f" ] && source "$f"
      done

      for f in "${modeConfig.modeConfigsPath}/zsh.d/*.zprofile"(N); do
        [ -r "$f" ] && source "$f"
      done
    '';

    # Always-loaded shell (.zshenv)
    envExtra = ''
      for f in "${hmPaths.homeCommonConfigsDir}/zsh.d/*.zshenv"(N); do
        [ -r "$f" ] && source "$f"
      done

      for f in "${modeConfig.modeConfigsPath}/zsh.d/*.zshenv"(N); do
        [ -r "$f" ] && source "$f"
      done
    '';
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    # Interactive shell (.bashrc)
    initExtra = ''
      for f in "${hmPaths.homeCommonConfigsDir}/bash.d/*.bashrc"; do
        [ -r "$f" ] && source "$f"
      done

      for f in "${modeConfig.modeConfigsPath}/bash.d/*.bashrc"; do
        [ -r "$f" ] && source "$f"
      done
    '';

    # Login shell (.bash_profile)
    profileExtra = ''
      for f in "${hmPaths.homeCommonConfigsDir}/bash.d/*.profile"; do
        [ -r "$f" ] && source "$f"
      done

      for f in "${modeConfig.modeConfigsPath}/bash.d/*.profile"; do
        [ -r "$f" ] && source "$f"
      done
    '';
  };

  # Enable Starship shell prompt
  programs.starship = {
    enable = true;
  };

  home.file.".config/starship.toml".source = hmPaths.homeCommonConfigsDir + "/starship.d/starship.toml";

  # Shared shell aliases (applied to all enabled shells)
  home.shellAliases = {
    ll = "ls -la";
    lt = "eza -laT --level ";
    gs = "git status";
    gl = "git log --oneline --graph --decorate";
    hm = "home-manager";
    hms = "home-manager switch --flake $DOTFILES_DIR#$HM_MODE_NAME";
    hml = "home-manager generations";
    hmpkgs = "home-manager packages";
  };

  # # Enable integration of session variables in shells
  # home.shell.enableShellIntegration = true;

  # Set login shell to zsh if it isn't already
  home.activation.setZshAsLoginShell = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    target_shell="${pkgs.zsh}/bin/zsh"
    current_shell=$(grep "^$USER:" /etc/passwd | cut -d: -f7 || echo "")

    if [ "$current_shell" != "$target_shell" ]; then
      if [ -x /usr/bin/chsh ]; then
        if grep -q "$target_shell" /etc/shells 2>/dev/null; then
          echo "🔁 Setting login shell to: $target_shell"
          /usr/bin/chsh -s "$target_shell" || echo "❌ Failed to set login shell with chsh."
        else
          echo "⚠️  $target_shell is not listed in /etc/shells"
          echo "👉 Run:  sudo sh -c 'echo $target_shell >> /etc/shells'"
        fi
      else
        echo "⚠️  'chsh' not found at /usr/bin/chsh. Skipping shell change."
      fi
    else
      echo "✅ Login shell is already set to $target_shell"
    fi
  '';
}

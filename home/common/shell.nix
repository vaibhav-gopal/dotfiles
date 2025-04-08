{ config, pkgs, lib, hmPaths, modeConfig, ... }:

let
  # List all valid shell fragment directories from enabled features
  featureShellDirs = builtins.filter builtins.pathExists (
    map (feature: "${hmPaths.homeFeaturesDir}/${feature}/shell.d") modeConfig.features
  );

  # Abstract fragment loader for shell stages (e.g. .zshrc, .zprofile)
  loadShellFragments = stageExt: dir: ''
    for f in "${dir}/*.${stageExt}"(N); do
      [ -r "$f" ] && source "$f"
    done
  '';

  # Common + mode-specific + feature fragment loaders combined
  shellStageFragments = stageExt: (
    loadShellFragments stageExt hmPaths.homeCommonConfigsDir + "/shell.d" +
    loadShellFragments stageExt modeConfig.modeConfigsPath + "/shell.d" +
    (lib.concatStrings (map (dir: loadShellFragments stageExt dir) featureShellDirs))
  );

in {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = shellStageFragments "zshrc";
    profileExtra = shellStageFragments "zprofile";
    envExtra = shellStageFragments "zshenv";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    initExtra = shellStageFragments "bashrc";
    profileExtra = shellStageFragments "profile";
  };

  programs.starship = {
    enable = true;
  };

  home.file.".config/starship.toml".source =
    hmPaths.homeCommonConfigsDir + "/starship.d/starship.toml";

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

  # Optional: shell integration if not already enabled by default
  # home.shell.enableShellIntegration = true;

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

{ config, pkgs, lib, hmPaths, modeConfig, ... }:

let
  # List all valid shell fragment directories from enabled features
  featureShellDirs = builtins.filter builtins.pathExists (
    map (feature: "${hmPaths.homeFeaturesDir}/${feature}/shell.d") modeConfig.features
  );

  # Abstract fragment loader for shell stages (e.g. .zshrc, .zprofile)
  loadShellFragments = stageExt: dir: "" +
    "if [ -d ${dir} ]; then\n" +
    "  for f in \"${dir}/*.${stageExt}\"; do\n" +
    "    [ -r \"$f\" ] && source \"$f\"\n" +
    "  done\n" +
    "fi\n";

  # Common + mode-specific + feature fragment loaders combined
  shellStageFragments = stageExt: (
    loadShellFragments stageExt (hmPaths.homeCommonConfigsDir + "/shell.d") +
    loadShellFragments stageExt (modeConfig.modeConfigsPath + "/shell.d") +
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

  home.file."${config.home.homeDirectory}/.config/starship.toml".source =
    hmPaths.homeCommonConfigsDir + "/shell.d/starship.toml";

  # Optional: shell integration if not already enabled
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

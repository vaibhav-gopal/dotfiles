{ config, lib, ... }:

let
  # Build candidate dirs as *strings* (not Nix paths), so missing dirs don't
  # explode at eval time. We'll filter by pathExists before using them.
  commonShellDir = "${config.paths.commonConfigsDir}/shell.d";
  modeShellDir   = "${config.paths.systemModule}/shell.d";

  # List all valid shell fragment directories from enabled features
  featureShellDirs = builtins.filter builtins.pathExists (
    map (feature: "${config.paths.featuresModule}/${feature}/shell.d") config.features.known-list
  );

  # Base dirs that actually exist
  existingBaseDirs =
    builtins.filter builtins.pathExists [ commonShellDir modeShellDir ];

  # Abstract fragment loader for shell stages (e.g. .zshrc, .zprofile)
  loadShellFragments = stageExt: dir: ''
    if [ -d "${dir}" ]; then
      while IFS= read -r f; do
        [ -r "$f" ] && . "$f"
      done < <(find "${dir}" -maxdepth 1 -type f -name "*.${stageExt}" 2>/dev/null)
    fi
  '';

  # Common + mode-specific + feature fragment loaders combined (only existing dirs)
  shellStageFragments = stageExt:
    lib.concatStrings (map (dir: loadShellFragments stageExt dir)
      (existingBaseDirs ++ featureShellDirs));

in {
  # shell integration if not already enabled
  home.shell.enableShellIntegration = true;

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = shellStageFragments "zshrc";
    profileExtra = shellStageFragments "zprofile";
    envExtra = shellStageFragments "zshenv";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    initExtra = shellStageFragments "bashrc";
    profileExtra = shellStageFragments "profile";
  };

  programs.direnv = {
    enable = true; # automaticaly load in .envrc files into the current shell
    nix-direnv.enable = false; # automatically run nix develop and nix shell
  };
}

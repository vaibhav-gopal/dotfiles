{ config, lib, hmPaths, configs, ... }:

let
  # Build candidate dirs as *strings* (not Nix paths), so missing dirs don't
  # explode at eval time. We'll filter by pathExists before using them.
  commonShellDir = "${hmPaths.homeCommonConfigsDir}/shell.d";
  modeShellDir   = "${configs.systemPath}/shell.d";

  # List all valid shell fragment directories from enabled features
  featureShellDirs = builtins.filter builtins.pathExists (
    map (feature: "${hmPaths.homeFeaturesDir}/${feature}/shell.d") configs.features
  );

  # Base dirs that actually exist
  existingBaseDirs =
    builtins.filter builtins.pathExists [ commonShellDir modeShellDir ];

  # Abstract fragment loader for shell stages (e.g. .zshrc, .zprofile)
  loadShellFragments = stageExt: dir: ''
    if [ -d "${dir}" ]; then
      for f in "${dir}"/*.${stageExt}; do
        [ -r "$f" ] && source "$f"
      done
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

  programs.starship = {
    enable = true;
  };

  home.file."${config.home.homeDirectory}/.config/starship.toml".source =
    hmPaths.homeCommonConfigsDir + "/shell.d/starship.toml";

  programs.direnv = {
    enable = true; # automaticaly load in .envrc files into the current shell
    nix-direnv.enable = false; # automatically run nix develop and nix shell
  };
}

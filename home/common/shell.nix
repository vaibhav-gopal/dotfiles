{ config, lib, hmPaths, configs, ... }:

let
  # List all valid shell fragment directories from enabled features
  featureShellDirs = builtins.filter builtins.pathExists (
    map (feature: "${hmPaths.homeFeaturesDir}/${feature}/shell.d") configs.features
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
    loadShellFragments stageExt (configs.systemPath + "/shell.d") +
    (lib.concatStrings (map (dir: loadShellFragments stageExt dir) featureShellDirs))
  );

in {
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

  # shell integration if not already enabled
  home.shell.enableShellIntegration = true;
}

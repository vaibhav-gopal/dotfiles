{ config, lib, ... }:

let 
  cfg = config.features.shell;

  # =================== SHELL FRAGMENT LOADER =======================
  # Build candidate dirs as *strings* (not Nix paths), so missing dirs don't explode at eval time. We'll filter by pathExists before using them.
  systemShellDirs = builtins.filter builtins.pathExists ["${config.paths.systemDir}/shell.d"];
  # List all valid shell fragment directories from enabled features
  featureShellDirs = builtins.filter builtins.pathExists (
    map (feature: "${config.paths.featuresDir}/${feature}/shell.d") config.features.known-list
  );
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
      (systemShellDirs ++ featureShellDirs));
in {
  options.features.shell = {
    enable = lib.mkEnableOption "Enable shell management and configuration";
    direnv = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable direnv ; automatic loading of .envrc files for environment variables.";
      };
      nix-direnv = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable nix-direnv ; automatic loading of env shells";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
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

    programs.direnv = lib.mkIf cfg.direnv.enable {
      enable = true; # automaticaly load in .envrc files into the current shell
      nix-direnv.enable = cfg.direnv.nix-direnv.enable; # automatically run nix develop and nix shell
    };
  };
}
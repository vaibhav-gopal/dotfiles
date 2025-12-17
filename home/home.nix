{ config, lib, hostname, nixType, ... }:
let
  commonFeaturesPath = ./features;
  nixtypePath = ./${nixType};
  nixtypeFeaturesPath = ./${nixType}/features;
  nixtypeSystemPath = ./${nixType}/${hostname};
in {
  # PATHS (read-only)
  options.extPaths = {
    readOnly = true;

    # dotfiles global directories
    dotfilesDir = lib.mkOption {
      type = lib.types.path;
      default = extDotfilesPath;
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles";
      description = "The location of the dotfiles directory, for use with raw symlinking / files out of nix store";
    };
    dotfilesEnvDir = lib.mkOption {
      type = lib.types.path;
      default = extEnvPath;
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles/env";
      description = "The location of the dotfiles env directory, for use with raw symlinking / files out of nix store";
    };
    dotfilesHomeDir = lib.mkOption {
      type = lib.types.path;
      default = extHomePath;
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles/home";
      description = "The location of the dotfiles home-manager directory, for use with raw symlinking / files out of nix store";
    };

    # per-nixtype + per-system overrides
    nixtypeDir = {
      type = lib.types.path;
      default = extFeaturesPath;
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles/home/${nixtype}";
  extDotfilesHomeFeaturesPath = "${config.home.homeDirectory}/dotfiles/home/features";;
      description = "The location of the dotfiles home-manager, per-nixtype overrides directory, for use with raw symlinking / files out of nix store";
    };
    nixtypeSystemDir = {
      type = lib.types.path;
      default = extFeaturesPath;
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles/home/${nixtype}/${hostname}";
      description = "The location of the dotfiles home-manager, per-nixtype, per-system overrides directory, for use with raw symlinking / files out of nix store";
    };

    # Feature directories
    commonFeaturesDir = lib.mkOption {
      type = lib.types.path;
      default = extFeaturesPath;
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles/home/features";
      description = "The location of the dotfiles home-manager common features directory, for use with raw symlinking / files out of nix store";
    };
    nixtypeFeaturesDir = {
      type = lib.types.path;
      default = extFeaturesPath;
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles/home/${nixtype}/features";
      description = "The location of the dotfiles home-manager, per-nixtype features directory, for use with raw symlinking / files out of nix store";
    };
  };

  # Expose parameterized features set and per-system overrides
  imports = [
    # Agnostic features
    commonFeaturesPath

    # Per nix-type overrides
    nixtypePath

    # Per nix-type features
    nixtypeFeaturesPath

    # Per system overrides
    nixtypeSystemPath
  ];
}

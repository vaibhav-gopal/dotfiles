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
      default = "${config.home.homeDirectory}/dotfiles";
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles";
      description = "The location of the dotfiles directory, for use with raw symlinking / files out of nix store";
    };
    dotfilesEnvDir = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/dotfiles/env";
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles/env";
      description = "The location of the dotfiles env directory, for use with raw symlinking / files out of nix store";
    };
    dotfilesHomeDir = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/dotfiles/home";
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles/home";
      description = "The location of the dotfiles home-manager directory, for use with raw symlinking / files out of nix store";
    };

    # per-nixType + per-system overrides
    nixtypeDir = {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/dotfiles/home/${nixType}";
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles/home/${nixType}";
      description = "The location of the dotfiles home-manager, per-nixType overrides directory, for use with raw symlinking / files out of nix store";
    };
    nixtypeSystemDir = {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/dotfiles/home/${nixType}/${hostname}";
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles/home/${nixType}/${hostname}";
      description = "The location of the dotfiles home-manager, per-nixType, per-system overrides directory, for use with raw symlinking / files out of nix store";
    };

    # Feature directories
    commonFeaturesDir = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/dotfiles/home/features";
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles/home/features";
      description = "The location of the dotfiles home-manager common features directory, for use with raw symlinking / files out of nix store";
    };
    nixtypeFeaturesDir = {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/dotfiles/home/${nixType}/features";
      defaultText = lib.literalExpression "${config.home.homeDirectory}/dotfiles/home/${nixType}/features";
      description = "The location of the dotfiles home-manager, per-nixType features directory, for use with raw symlinking / files out of nix store";
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

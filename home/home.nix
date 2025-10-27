{ config, lib, hostname, nixType, ... }:
let
  extDotfilesPath = "${config.home.homeDirectory}/dotfiles";
  extHomePath = "${config.home.homeDirectory}/dotfiles/home";
  extFeaturesPath = "${config.home.homeDirectory}/dotfiles/home/features";

  featuresPath = ./features;
  nixTypePath = ./${nixType};
  nixTypeFeaturesPath = ./${nixType}/features;
  systemPath = ./${nixType}/${hostname};
in {
  options.extPaths = {
    dotfilesDir = lib.mkOption {
      type = lib.types.path;
      default = extDotfilesPath;
      defaultText = lib.literalExpression extDotfilesPath;
      description = "The location of the dotfiles directory, for use with raw symlinking out of nix store";
    };
    homeDir = lib.mkOption {
      type = lib.types.path;
      default = extHomePath;
      defaultText = lib.literalExpression extHomePath;
      description = "The location of the dotfiles home directory, for use with raw symlinking out of nix store";
    };
    featuresDir = lib.mkOption {
      type = lib.types.path;
      default = extFeaturesPath;
      defaultText = lib.literalExpression extFeaturesPath;
      description = "The location of the dotfiles home features directory, for use with raw symlinking out of nix store";
    };
  };
  options.paths = {
    # PATHS
    featuresDir = lib.mkOption {
      type = lib.types.path;
      default = featuresPath;
      defaultText = lib.literalExpression "./features";
      description = "The location of the parameterized features for home manager";
    };
    nixTypeDir = lib.mkOption {
      type = lib.types.path;
      default = nixTypePath;
      defaultText = lib.literalExpression "./${nixType}";
      description = "The location of the nix type specific home manager overrides";
    };
    nixTypeFeaturesDir = lib.mkOption {
      type = lib.types.path;
      default = nixTypeFeaturesPath;
      defaultText = lib.literalExpression "./${nixType}/features";
      description = "The location of the specific nix-type parameterized features for home manager";
    };
    systemDir = lib.mkOption {
      type = lib.types.path;
      default = systemPath;
      defaultText = lib.literalExpression "./${hostname}";
      description = "The location of the system specific home manager overrides";
    };
  };

  # Expose parameterized features set and per-system overrides
  imports = [
    # Agnostic features
    featuresPath

    # Per nix-type overrides
    nixTypePath

    # Per nix-type features
    nixTypeFeaturesPath

    # Per system overrides
    systemPath
  ];
}
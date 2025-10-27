{ lib, hostname, nixType, ... }:
let
  featuresPath = ./features;
  nixTypePath = ./${nixType};
  nixTypeFeaturesPath = ./${nixType}/features;
  systemPath = ./${nixType}/${hostname};
in {
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
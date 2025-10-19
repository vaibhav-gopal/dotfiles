args@{ pkgs, pkgs-unstable, config, lib, username, hostname, ... }:
let
  featuresPath = ./features;
  systemPath = ./${username}_${hostname};
in {
  options.paths = {
    # PATHS
    featuresDir = lib.mkOption {
      type = lib.types.path;
      default = featuresPath;
      defaultText = lib.literalExpression "./features";
      description = "The location of the parameterized features for home manager";
    };
    systemDir = lib.mkOption {
      type = lib.types.path;
      default = systemPath;
      defaultText = lib.literalExpression "./${username}_${hostname}";
      description = "The location of the system/user specific home manager overrides / setup";
    };
  };

  # Expose common home manager files, parameterized features and per-system overrides
  imports = [
    featuresPath
    systemPath
  ];
}
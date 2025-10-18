args@{ pkgs, pkgs-unstable, config, lib, username, hostname, ... }:
let
  # Important paths to define and load immediately!
  options.paths = {
    # SUB MODULES
    commonModule = lib.mkOption {
      type = lib.types.path;
      default = ./common;
      defaultText = lib.literalExpression "./common";
      description = "The location of the common home manager configs nix files";
    };
    featuresModule = lib.mkOption {
      type = lib.types.path;
      default = ./features;
      defaultText = lib.literalExpression "./features";
      description = "The location of the parameterized features for home manager";
    };
    systemModule = lib.mkOption {
      type = lib.types.path;
      default = ./${username}_${hostname};
      defaultText = lib.literalExpression "./${username}_${hostname}";
      description = "The location of the system/user specific home manager overrides / setup";
    };

    # PATHS
    commonConfigsDir = lib.mkOption {
      type = lib.types.paths;
      default = ./common/configs;
      defaultText = lib.literalExpression "./common/configs";
      description = "The location of the common configs directory";
    };
  };
in {
  inherit options;

  # Expose common home manager files, parameterized features and per-system overrides
  imports = [
    config.paths.commonModule
    config.paths.featuresModule
    config.paths.systemModule
  ];
}
{ config, lib, usrlib, hostname, nixType, ... }:
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
    dotfilesDir = usrlib.mkPathOption "The location of the dotfiles directory, for use with raw symlinking / files out of nix store" "${config.home.homeDirectory}/dotfiles";
    dotfilesEnvDir = usrlib.mkPathOption "The location of the dotfiles env directory, for use with raw symlinking / files out of nix store" "${config.home.homeDirectory}/dotfiles/env";
    dotfilesHomeDir = usrlib.mkPathOption "The location of the dotfiles home-manager directory, for use with raw symlinking / files out of nix store" "${config.home.homeDirectory}/dotfiles/home";

    # per-nixType + per-system overrides
    nixtypeDir = usrlib.mkPathOption "The location of the dotfiles home-manager, per-nixType overrides directory, for use with raw symlinking / files out of nix store" "${config.home.homeDirectory}/dotfiles/home/${nixType}";
    nixtypeSystemDir = usrlib.mkPathOption "The location of the dotfiles home-manager, per-nixType, per-system overrides directory, for use with raw symlinking / files out of nix store" "${config.home.homeDirectory}/dotfiles/home/${nixType}/${hostname}";

    # Feature directories
    commonFeaturesDir = usrlib.mkPathOption "The location of the dotfiles home-manager common features directory, for use with raw symlinking / files out of nix store" "${config.home.homeDirectory}/dotfiles/home/features";
    nixtypeFeaturesDir = usrlib.mkPathOption "The location of the dotfiles home-manager, per-nixType features directory, for use with raw symlinking / files out of nix store" "${config.home.homeDirectory}/dotfiles/home/${nixType}/features";
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

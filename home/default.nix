{ config, usrlib, hostname, nixType, ... }:
let
  modulesPath = ./modules;
  nixtypePath = ./${nixType};
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

    # Module directories
    commonModulesDir = usrlib.mkPathOption "The location of the dotfiles home-manager common modules directory, for use with raw symlinking / files out of nix store" "${config.home.homeDirectory}/dotfiles/home/modules";
    nixtypeModulesDir = usrlib.mkPathOption "The location of the dotfiles home-manager, per-nixType modules directory, for use with raw symlinking / files out of nix store" "${config.home.homeDirectory}/dotfiles/home/${nixType}/modules";
  };

  # Expose parameterized features set and per-system overrides
  imports = [
    # Agnostic features
    modulesPath

    # Per nix-type overrides
    nixtypePath
  ];
}

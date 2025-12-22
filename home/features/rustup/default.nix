{ config, lib, pkgs, ... }:

let 
  cfg = config.features.rustup;
in {
  options.features.rustup = {
    enable = lib.mkEnableOption "Enable rustup : rust toolchain manager" // { default = true; };
    enable_auto_install_toolchain = lib.mkEnableOption "Auto install toolchains from rust-toolchain.toml from local directory" // { default = false; };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.rustup;
      defaultText = lib.literalExpression "pkgs.rustup";
      description = "The rustup package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    home.sessionVariables = {
      CARGO_HOME = "${config.home.homeDirectory}/.cargo";
      RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
      RUSTUP_AUTO_INSTALL = "${if cfg.enable_auto_install_toolchain then "1" else "0"}";
    };
  };
}
{ config, lib, pkgs-unstable, usrlib, ... }:

let 
  cfg = config.common.rustup;
in {
  options.common.rustup = {
    enable = usrlib.mkEnableOptionTrue "Enable rustup : rust toolchain manager";
    enable_auto_install_toolchain = usrlib.mkEnableOptionFalse "Auto install toolchains from rust-toolchain.toml from local directory";
    package = usrlib.mkPackageOption "The rustup package to use" pkgs-unstable.rustup;
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
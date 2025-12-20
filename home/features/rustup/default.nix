{ config, lib, pkgs, ... }:

let 
  cfg = config.features.rustup;
in {
  options.features.rustup = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable rustup : rust toolchain manager";
    };
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
    };
  };
}
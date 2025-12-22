{ config, lib, pkgs, ... }:

let 
  cfg = config.features.cpp;
in {
  options.features.cpp = {
    enable = lib.mkEnableOption "Enable c++ build and dev tools" // { default = true; };
    packages = {
      gcc = lib.mkOption {
        type = lib.types.package;
        default = pkgs.gcc;
        defaultText = lib.literalExpression "pkgs.gcc";
        description = "The gcc package to use for cpp feature";
      };
      gnumake = lib.mkOption {
        type = lib.types.package;
        default = pkgs.gnumake;
        defaultText = lib.literalExpression "pkgs.gnumake";
        description = "The gnumake package to use for cpp feature";
      };
      cmake = lib.mkOption {
        type = lib.types.package;
        default = pkgs.cmake;
        defaultText = lib.literalExpression "pkgs.cmake";
        description = "The cmake package to use for cpp feature";
      };
      gdb = lib.mkOption {
        type = lib.types.package;
        default = pkgs.gdb;
        defaultText = lib.literalExpression "pkgs.gdb";
        description = "The gdb package to use for cpp feature";
      };
      pkg-config = lib.mkOption {
        type = lib.types.package;
        default = pkgs.pkg-config;
        defaultText = lib.literalExpression "pkgs.pkg-config";
        description = "The pkg-config package to use for cpp feature";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with cfg.packages; [
      gcc
      gnumake
      cmake
      gdb
      pkg-config
    ];
  };
}
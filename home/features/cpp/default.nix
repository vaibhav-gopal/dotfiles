{ config, lib, pkgs, usrlib, ... }:

let 
  cfg = config.features.cpp;
in {
  options.features.cpp = {
    enable = usrlib.mkEnableOptionTrue "Enable c++ build and dev tools";
    packages = {
      gcc = usrlib.mkPackageOption "The gcc package to use for cpp feature" pkgs.gcc;
      gnumake = usrlib.mkPackageOption "The gnumake package to use for cpp feature" pkgs.gnumake;
      cmake = usrlib.mkPackageOption "The cmake package to use for cpp feature" pkgs.cmake;
      gdb = usrlib.mkPackageOption "The gdb package to use for cpp feature" pkgs.gdb;
      pkg-config = usrlib.mkPackageOption "The pkg-config package to use for cpp feature" pkgs.pkg-config;
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
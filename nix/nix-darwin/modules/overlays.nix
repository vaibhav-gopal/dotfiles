{ config, lib, usrlib, claude-code, ... }:

let
  cfg = config.modules.extraInputs;
in {
  options.modules.extraInputs = {
    claude-code = {
      enable = usrlib.mkEnableOptionTrue "enable claude-code overlay";
    };
  };

  config = {
    nixpkgs.overlays = lib.mkIf cfg.claude-code.enable [
      claude-code.overlays.default
    ];
  };
}
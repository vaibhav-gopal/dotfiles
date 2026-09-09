{ config, lib, pkgs, usrlib, claude-code, ... }:
let
  cfg = config.common.claude-code;
in {
  options.common.claude-code = {
    enable = usrlib.mkEnableOptionTrue "Enable Claude Code";
    package = usrlib.mkPackageOption "The Claude Code package to install"
      (claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code or pkgs.claude-code);
    alias = usrlib.mkStringOption "Optional shell alias for Claude Code (empty disables alias)" "";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.shellAliases = lib.mkIf (cfg.alias != "") {
      ${cfg.alias} = "claude";
    };
  };
}

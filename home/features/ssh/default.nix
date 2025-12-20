{ config, lib, pkgs, ... }:

let 
  cfg = config.features.ssh;
in {
  options.features.ssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ssh configuration";
    };
    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.openssh;
      defaultText = lib.literalExpression "pkgs.openssh";
      description = "The ssh package to use ; if null, uses system package (was default)";
    };
    extraConfig = lib.mkOption {
      default = ''
        ServerAliveInterval 30
        ServerAliveCountMax 30
      '';
      type = lib.types.lines;
      description = ''
        Extra configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      package = cfg.package;
      extraConfig = cfg.extraConfig;

      # Equivalent default config with match blocks (default config will be deprecated in a later release)
      enableDefaultConfig = false;
      matchBlocks."*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };
}

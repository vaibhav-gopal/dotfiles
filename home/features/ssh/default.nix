{ config, lib, pkgs, usrlib, ... }:

let 
  cfg = config.features.ssh;
in {
  options.features.ssh = {
    enable = usrlib.mkEnableOptionTrue "Enable ssh configuration";
    package = usrlib.mkNullOrPackageOption "The ssh package to use ; if null, uses system package (was default)" pkgs.openssh;
    extraConfig = usrlib.mkLinesOption 
    "Extra configuration." 
    ''
      ServerAliveInterval 30
      ServerAliveCountMax 30
    '';
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

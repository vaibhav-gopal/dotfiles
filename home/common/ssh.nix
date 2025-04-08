{ config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      ServerAliveInterval 30
      ServerAliveCountMax 3
    '';
  };

  home.packages = with pkgs; [
    openssh  # provides ssh, scp, sftp, ssh-keygen, etc.
    rsync    # for remote and local sync
  ];

  home.shellAliases = {
    sshsync = "rsync -avz --progress";
    sshex = "ssh -A";
    scpsync = "rsync -e ssh -avz --progress";
  };
}

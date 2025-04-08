{ config, pkgs, lib, ... }:

{
    # Ensure rsync is installed (home/common/ssh.nix)
    home.packages = with pkgs; [ rsync ];

    # User-level systemd service for rsync daemon (optional)
    systemd.user.services.rsyncd = {
        Unit = {
            Description = "User-level rsync daemon";
        };
        Service = {
            ExecStart = "${pkgs.rsync}/bin/rsync --daemon --no-detach";
            Restart = "on-failure";
        };
        Install = {
            WantedBy = [ "default.target" ];
        };
    };
}
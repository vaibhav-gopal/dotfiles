{ config, pkgs, lib, ... }:

{
    # Minimal essential compression and archiving tools
    home.packages = with pkgs; [
        zip
        unzip
        gzip
        xz
        tar
    ];

    home.shellAliases = {
        targz = "tar -czvf";
        tarxz = "tar -cJvf";
        ungz  = "gzip -d";
        unxz  = "xz -d";
    };
}

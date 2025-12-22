{ config, ... }:
{
  # manually add the systems hardware config!
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    features.graphics = {
      enable = true;
      video_drivers = ["nvidia" "amdgpu"];
      nvidia = {
        enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime = {
          enable = true;
          nvidiaBusId = "PCI:1:0:0";
          amdgpuBusId = "PCI:115:0:0";
        };
      };
    };

    # bluetooth module (mt7925e - MediaTek Wifi 7 + Bluetooth 5.4)
    # getting boot messages / kernel messages with -110 error (failing enter/exit LP states)
    # disable ASPM (active state power management)
    # boot.kernelParams = [ "mt7925e.disable_aspm=1" ];
  };


}

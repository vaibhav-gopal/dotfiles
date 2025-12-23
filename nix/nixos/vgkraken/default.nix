{ config, ... }:
{
  # manually add the systems hardware config!
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    core.graphics = {
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

    # ISSUE:
    # bluetooth module (mt7925e - MediaTek Wifi 7 + Bluetooth 5.4)
    # getting boot messages / kernel messages with -110 error (failing enter/exit LP states)
    # prevents usb devices connected to the same bus from initializing immediately!!!

    # SOLVED:
    # literally just a windows dual boot issue ; need to do a full power cycle and capacitor discharge (everything)
    # disable hibernate + fast startup ; cold boot into nix immediately... should solve it

    # POSSIBLE FIXES (OLD):
    # disable ASPM (active state power management)
    # boot.kernelParams = [ "mt7925e.disable_aspm=1" ];
    # force btusb
    # boot.extraModprobeConfig = ''
    #   options btusb enable_autosuspend=0
    # '';
    # can also help with bluetooth issue ; related to how cpu handles memory mapping for usb devices
    # boot.kernelParams = [ "iommu=soft" ];
  };


}

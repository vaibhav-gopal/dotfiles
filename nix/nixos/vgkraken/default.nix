{ config, ... }:
{
  # manually add the systems hardware config!
  imports = [
    ./hardware-configuration.nix
  ];

  config.features.graphics = {
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
}

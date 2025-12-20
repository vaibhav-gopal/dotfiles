{ config, ... }:
{
  # enable hardware acceleration
  hardware.graphics.enable = true;

  # xserver graphics drivers to use (don't combine free ; mesa-based ; with proprietary drivers ; nvidia/amd)
  services.xserver.videoDrivers = ["nvidia" "amdgpu"];

  # enable nvidia drivers (PRIME options/service allows both nvidia + amd iGPU runtime switching for performance / efficiency)
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      # using the lshw package ; sudo lshw -c display
      # remove leading zeros ; replace . with : ; convert hex to decimal ; capitalize PCI ; remove the @0000 part
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:115:0:0";

      sync.enable = true;
    };
  };
}

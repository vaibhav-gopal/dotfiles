{ config, lib, usrlib, ... }:
let
  cfg = config.core.graphics;
in {
  options.core.graphics = {
    enable = usrlib.mkEnableOptionTrue "enable graphics hardware acceleration";
    video_drivers = usrlib.mkListOfEnumOption "xserver graphics drivers to use, in order (don't mix free MESA-based w/ unfree proprietary drivers)" ["modesetting" "fbdev"] ["nvidia" "amdgpu" "modesetting" "fbdev"];
    nvidia = {
      enable = usrlib.mkEnableOptionTrue "enable nvidia driver user configuration (factory config will be automatically enabled if hardware present regardless of this option)";
      package = usrlib.mkPackageOption "The nvidia driver version package to use" config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        enable = usrlib.mkEnableOptionTrue "enable nvidia PRIME iGPU/GPU sync";
        nvidiaBusId = usrlib.mkStringOption "The PCI Bus ID for an Nvidia GPU for Nvidia PRIME" "";
        amdgpuBusId = usrlib.mkStringOption "The PCI Bus ID for an AMD iGPU/GPU for Nvidia PRIME" "";
        intelBusId = usrlib.mkStringOption "The PCI Bus ID for an Intel iGPU/GPU for Nvidia PRIME" "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # enable hardware acceleration
    hardware.graphics.enable = true;

    # xserver graphics drivers to use (don't combine free ; mesa-based ; with proprietary drivers ; nvidia/amd)
    services.xserver.videoDrivers = cfg.video_drivers;

    # enable nvidia drivers (PRIME options/service allows both nvidia + amd iGPU runtime switching for performance / efficiency)
    hardware.nvidia = lib.mkIf cfg.nvidia.enable {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = true;

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
      package = cfg.nvidia.package;

      prime = lib.mkIf cfg.nvidia.prime.enable {
        # using the lshw package ; sudo lshw -c display
        # remove leading zeros ; replace . with : ; convert hex to decimal ; capitalize PCI ; remove the @0000 part
        nvidiaBusId = cfg.nvidia.prime.nvidiaBusId;
        amdgpuBusId = cfg.nvidia.prime.amdgpuBusId;
        intelBusId = cfg.nvidia.prime.intelBusId;

        sync.enable = true;
      };
    };
  };
}

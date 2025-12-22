{ config, lib, ... }:
let
  cfg = config.features.audio;
in {
  options.features.audio = {
    enable = lib.mkEnableOption "enable sound with pipewire and pulseaudio" // { default = true; };
    enable_jack = lib.mkEnableOption "enable JACK audio emulation" // { default = true; };
  };

  config = lib.mkIf cfg.enable {
    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = cfg.enable_jack; # enable JACK audio emulation
    };
  };
}

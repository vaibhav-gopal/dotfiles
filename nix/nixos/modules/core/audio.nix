{ config, lib, usrlib, ... }:
let
  cfg = config.core.audio;
in {
  options.core.audio = {
    enable = usrlib.mkEnableOptionTrue "enable sound with pipewire and pulseaudio";
    enable_jack = usrlib.mkEnableOptionTrue "enable JACK audio emulation";
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
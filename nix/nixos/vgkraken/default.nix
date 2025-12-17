{ inputs, ... }:
{
  # manually add the systems hardware config!
  imports = [
    "${inputs.hardware}/vgkraken/hardware-configuration.nix"
  ];
}

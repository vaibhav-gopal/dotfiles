{ hostname, username, version, homedirectory, ... }:

{
  imports = [
    ./audio.nix
    ./boot.nix
    ./connectivity.nix
    ./desktop.nix
    ./devices.nix
    ./env.nix
    ./graphics.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = version; # Did you read the comment?

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "Vaibhav Gopal";
    home = homedirectory;
    extraGroups = [ "networkmanager" "wheel" ];
  };
  networking.hostName = hostname; # Define your hostname.
}

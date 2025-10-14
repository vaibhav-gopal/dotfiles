{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-25.05;
    nixos-wsl.url = github:nix-community/NixOS-WSL/release-25.05;
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = x86_64-linux;
        modules = [
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = 25.05;
            wsl.enable = true;
	          wsl.defaultUser = "vaibhav";
            networking.hostName = "vgwsl2";
          }
        ];
      };
    };
  };
}

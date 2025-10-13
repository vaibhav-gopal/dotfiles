{ hmPaths, username, hostname, ... }:

let 
  systemPath = "${hmPaths.homeDir}/${username}_${hostname}";
  configName = "${username}@${hostname}";
  featuresSet = {
    "vaibhav@vgmacbook" = [
      "bun"
      "cpp"
      "glow"
      "neovim"
      "rustup"
      "uv"
    ];
    "vaibhav@vgwsl2" = [
      "bun"
      "cpp"
      "glow"
      "neovim"
      "rustup"
      "uv"
    ];
  };
  featuresDefault = [
      "bun"
      "cpp"
      "glow"
      "neovim"
      "rustup"
      "uv"
  ];
in {
  inherit systemPath configName;
  # Get relevant feature set or set default!
  features = featuresSet."${configName}" or featuresDefault;
}


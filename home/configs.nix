{ hmPaths, username, hostname, ... }:

let 
  systemPath = "${hmPaths.homeDir}/${username}_${hostname}";
  configName = "${username}@${hostname}";
  featuresSet = {
    "vaibhav@vgmacbook" = [
      "bun"
      "rustup"
      "cpp"
      "glow"
      "neovim"
      "uv"
    ];
  };
  featuresDefault = [
      "bun"
      "rustup"
      "cpp"
      "glow"
      "neovim"
      "uv"
  ];
in {
  inherit systemPath configName;
  # Get relevant feature set or set default!
  features = featuresSet."${configName}" or featuresDefault;
}


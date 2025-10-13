{ username, hostname, ... }:

let 
  systemPath = ./${username}_${hostname};
  configName = "${username}@${hostname}";
  featuresSet = {
    "vaibhav@vgmacbook" = [
      "bun"
      "cpp"
      "glow"
      "rustup"
      "uv"
    ];
    "vaibhav@vgwsl2" = [
      "bun"
      "cpp"
      "glow"
      "rustup"
      "uv"
    ];
  };
  featuresDefault = [
      "bun"
      "cpp"
      "glow"
      "rustup"
      "uv"
  ];
in {
  inherit systemPath configName;
  # Get relevant feature set or set default!
  features = featuresSet."${configName}" or featuresDefault;
}


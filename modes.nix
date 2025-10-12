{ hmPaths }:

[
  (let
    username = "vaibhav";
    mode = "ubuntu";
    modePath = "${hmPaths.homeDir}/${username}_${mode}";
  in {
    inherit username mode modePath;
    modeName = "${username}@${mode}";
    modeConfigsPath = modePath + "/localconfigs";
    system = "x86_64-linux";
    version = "25.11";
    features = [
      "bun"
      "rustup"
      "cpp"
      "glow"
      "neovim"
      "uv"
    ];
  })

  (let
    username = "vaibhav";
    mode = "Vaibhavs-MacBook-Pro";
    modePath = "${hmPaths.homeDir}/${username}_${mode}";
  in {
    inherit username mode modePath;
    modeName = "${username}@${mode}";
    modeConfigsPath = modePath + "/localconfigs";
    system = "aarch64-darwin";
    version = "25.11";
    features = [
      "bun"
      "rustup"
      "cpp"
      "glow"
      "neovim"
      "uv"
    ];
  }) 
]

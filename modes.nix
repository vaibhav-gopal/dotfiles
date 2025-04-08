{ hmPaths }:

[
  (let
    username = "vaibhav";
    mode = "wsl2";
    modePath = "${hmPaths.homeDir}/${username}_${mode}";
  in {
    inherit username mode modePath;
    modeName = "${username}@${mode}";
    modeConfigsPath = modePath + "/localconfigs";
    system = "x86_64-linux";
    version = "24.11";
    features = [
      "helix"
      "bun"
      "cargo"
      "micromamba"
      "nvm"
    ];
  })

  (let
    username = "vaibhav";
    mode = "macbook";
    modePath = "${hmPaths.homeDir}/${username}_${mode}";
  in {
    inherit username mode modePath;
    modeName = "${username}@${mode}";
    modeConfigsPath = modePath + "/localconfigs";
    system = "x86_64-darwin";
    version = "24.11";
    features = [
      "helix"
      "bun"
      "cargo"
      "micromamba"
      "nvm"
    ];
  }) 
]

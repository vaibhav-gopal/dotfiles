{ hmPaths }:

[
  (let
    username = "vaibhav";
    mode = "wsl2";
  in {
    inherit username mode;
    modeName = "${username}@${mode}";
    modePath = "${hmPaths.homeDir}/${username}_${mode}/home.nix";
    system = "x86_64-linux";
    version = "24.11";
    features = [
      "helix"
    ];
  })

  (let
    username = "vaibhav";
    mode = "macbook";
  in {
    inherit username mode;
    modeName = "${username}@${mode}";
    modePath = "${hmPaths.homeDir}/${username}_${mode}/home.nix";
    system = "x86_64-darwin";
    version = "24.11";
    features = [
      "helix"
    ];
  }) 
]

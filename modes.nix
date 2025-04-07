[
  (let
    username = "vaibhav";
    mode = "wsl2";
    modeName = "${username}@${mode}";
    modePath = "./home/${username}_${mode}/home.nix";
  in {
    inherit username mode modeName modePath;
    system = "x86_64-linux";
  })
  
  (let
    username = "vaibhav";
    mode = "macbook";
    modeName = "${username}@${mode}";
    modePath = "./home/${username}_${mode}/home.nix";
  in {
    inherit username mode modeName modePath;
    system = "x86_64-darwin";
  })
]

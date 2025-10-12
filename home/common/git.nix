{ config, pkgs, lib, hmPaths, configs, ... }:

{
  # Enable Git with a default identity
  programs.git = {
    enable = true;

    userName = "Vaibhav Gopal";
    userEmail = "vaibhav@gmail.com";

    extraConfig = {
      # Default editor
      core = {
        editor = "nvim";
      };

      # Per git command overrides for pager
      pager = {
        diff = "delta";
        log = "delta";
        show = "delta";
      };
      
      init.defaultBranch = "main";
    };

    # Use delta formatter for diffs
    delta = {
      enable = true;
    };
  };

  # Enable GitHub CLI (gh)
  programs.gh = {
    enable = true;

    settings = {
      prompt = "enabled";
      git_protocol = "https";  # or "ssh" if you prefer
    };
  };

  # Git / Github Shell Aliases
  home.shellAliases = {
    gs = "git status";
    gl = "git log --oneline --graph --decorate";
  };
}

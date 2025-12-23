{ config, lib, pkgs, usrlib, ... }:

let 
  cfg = config.features.git;
in {
  options.features.git = {
    enable = usrlib.mkEnableOptionTrue "Enable git configuration management";
    name = usrlib.mkStringOption "Name for git config" "Vaibhav Gopal";
    email = usrlib.mkStringOption "Email for git config" "vaibhav@gmail.com";
    package = usrlib.mkPackageOption "The git package to use" pkgs.git;
    gh = {
      enable = usrlib.mkEnableOptionTrue "Enable the GH CLI";
      package = usrlib.mkPackageOption "The gh cli package to use" pkgs.gh;
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable Git with a default identity
    programs.git = {
      enable = true;

      settings = {
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

        user.email = cfg.email;
        user.name = cfg.name;
      };
    };

    # Use delta formatter for diffs
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
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
  };
}

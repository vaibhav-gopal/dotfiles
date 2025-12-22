{ config, lib, pkgs, ... }:

let 
  cfg = config.features.git;
in {
  options.features.git = {
    enable = lib.mkEnableOption "Enable git configuration management" // { default = true; };
    name = lib.mkOption {
      type = lib.types.str;
      default = "Vaibhav Gopal";
      description = "Name for git config";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "vaibhav@gmail.com";
      description = "Email for git config";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.git;
      defaultText = lib.literalExpression "pkgs.git";
      description = "The git package to use";
    };
    gh = {
      enable = lib.mkEnableOption "Enable the GH CLI" // { default = true; };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.gh;
        defaultText = lib.literalExpression "pkgs.gh";
        description = "The gh cli package to use";
      };
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

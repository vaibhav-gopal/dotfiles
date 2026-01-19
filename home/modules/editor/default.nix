{ config, lib, pkgs, pkgs-unstable, usrlib, ... }:

let 
  cfg = config.common.editor;
in {
  options.common.editor = {
    enable = usrlib.mkEnableOptionTrue "Enable vim feature";
    default = usrlib.mkEnumOption "Configure the default $EDITOR and $VISUAL" "nvim" ["vim" "nvim"];
    nvim = {
      enable = usrlib.mkEnableOptionTrue "Enable nvim package and feature";
      package = usrlib.mkPackageOption "The neovim package to use (Uses unwrapped by default in programs)" pkgs.neovim-unwrapped;
    };
    vscodevim = {
      enable = usrlib.mkEnableOptionTrue "Enable vscode vimrc file setup";
    };
    zed = {
      enable = usrlib.mkEnableOptionTrue "Enable zed editor application";
      package = usrlib.mkPackageOption "The zed editor package to use" pkgs-unstable.zed-editor;
    };
  };

  config = lib.mkIf cfg.enable {
    # VIM
    programs.vim = {
      enable = true;
      defaultEditor = lib.mkIf (cfg.default == "vim") true;
    };
    home.file."${config.home.homeDirectory}/.vimrc".source =
      lib.mkIf cfg.nvim.enable
      (config.lib.file.mkOutOfStoreSymlink "${config.extPaths.commonModulesDir}/editor/vim.d/vimrc");

    # NEOVIM
    programs.neovim = {
      enable = cfg.nvim.enable;
      package = cfg.nvim.package;
      defaultEditor = lib.mkIf (cfg.default == "nvim") true;
    };
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.extPaths.commonModulesDir}/editor/nvim.d";
    
    # VSCODE VIMRC
    home.file."${config.home.homeDirectory}/.vscodevimrc".source = 
      lib.mkIf cfg.vscodevim.enable
      (config.lib.file.mkOutOfStoreSymlink "${config.extPaths.commonModulesDir}/editor/vim.d/vimrc");

    # ZED EDITOR
    programs.zed-editor = {
      enable = cfg.zed.enable;
      package = cfg.zed.package;
      extensions = ["nix" "toml" "dockerfile"];
      userSettings = {
        theme = {
          mode = "system";
          dark = "One Dark";
          light = "One Light";
        };
        hour_format = "hour24";
        vim_mode = true;
      };
    };
  };
}

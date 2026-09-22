{ config, lib, pkgs, usrlib, ... }:
let
  cfg = config.common.freerdp;

  hostOption = lib.types.submodule ({ name, ... }: {
    options = {
      host = usrlib.mkStringOption "Server to connect to (`/v:`); hostname, Tailscale name or IP" name;
      user = usrlib.mkNullOrStringOption "Username (`/u:`); null prompts / uses the server default" null;
      domain = usrlib.mkNullOrStringOption "Windows domain (`/d:`)" null;
      useDefaultArgs = usrlib.mkEnableOptionTrue "Prepend `common.freerdp.defaultArgs` to this host's args";
      extraArgs = usrlib.mkListOfStringsOption "Extra sdl-freerdp args for this host only, appended after defaultArgs" [ ];
      app = usrlib.mkEnableOptionFalse "Also build a dockable `RDP <name>.app` (macOS only, via nixtype.apps)";
    };
  });

  hostCmd = name: h: lib.concatStringsSep " " (
    [ "sdl-freerdp" "/v:${h.host}" ]
    ++ lib.optional (h.user != null) "/u:${h.user}"
    ++ lib.optional (h.domain != null) "/d:${h.domain}"
    ++ lib.optionals h.useDefaultArgs cfg.defaultArgs
    ++ h.extraArgs
  );
in {
  # MODULE OPTIONS DECLARATION
  options.common.freerdp = {
    enable = usrlib.mkEnableOptionFalse "Enable the FreeRDP remote desktop client. The package has no `freerdp` binary: `sdl-freerdp` is the native-window client, `xfreerdp` needs an X server (XQuartz on macOS).";
    package = usrlib.mkPackageOption "The freerdp package to use" pkgs.freerdp;
    alias = usrlib.mkStringOption "Shell alias pointing at `sdl-freerdp` (empty disables alias)" "freerdp";

    defaultArgs = usrlib.mkListOfStringsOption "sdl-freerdp args shared by every host in `hosts` (unless a host sets useDefaultArgs = false)" [
      "/dynamic-resolution" # resize the session with the window
      "+clipboard"          # copy-paste both ways
      "/gfx:AVC444"         # H.264 - much better over WAN
      "/network:auto"       # auto-tune for link quality
    ];
    hostAliasPrefix = usrlib.mkStringOption "Prefix for the per-host aliases: `<prefix><name>`" "rdp-";
    hosts = lib.mkOption {
      type = lib.types.attrsOf hostOption;
      default = { };
      example = lib.literalExpression ''
        {
          winpc = { user = "me"; };                                   # -> rdp-winpc, /v:winpc
          work  = { host = "10.0.0.5"; user = "me"; domain = "CORP";
                    extraArgs = [ "/f" "/multimon" ]; };
        }
      '';
      description = "Saved connections, one `<hostAliasPrefix><name>` alias each. Passwords are never stored: sdl-freerdp prompts.";
    };
  };

  # MODULE BODY
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.shellAliases =
      lib.optionalAttrs (cfg.alias != "") { ${cfg.alias} = "sdl-freerdp"; }
      // lib.mapAttrs' (name: h: lib.nameValuePair "${cfg.hostAliasPrefix}${name}" (hostCmd name h)) cfg.hosts;
  };
}

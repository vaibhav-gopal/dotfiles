# Dockable macOS .app bundles wrapping a shell command - "extended aliases".
#
# Each entry in `nixtype.apps` becomes `<name>.app` under
# ~/Applications/Home Manager Apps (home-manager's copyApps step picks up any
# package with an Applications/ output), so it is dockable, Spotlight-able and
# gets its own Dock icon. The bundle is just an Info.plist plus a bash launcher.
#
# Launched from the Dock there is no stdin/tty, so anything interactive must
# either set `terminal = true` (runs inside the terminal emulator) or take its
# secrets from the macOS Keychain - see the freerdp bridge at the bottom.
{ config, lib, pkgs, usrlib, ... }:

let
  cfg = config.nixtype.apps;
  rdp = config.common.freerdp;

  appOption = lib.types.submodule ({ name, ... }: {
    options = {
      command = usrlib.mkStringOption "Shell command to run (bash). Use absolute store paths; the Dock's PATH is minimal" "";
      terminal = usrlib.mkEnableOptionFalse "Run the command inside `nixtype.apps.terminalCommand` instead of headless";
      icon = usrlib.mkNullOrPathOption "Optional .icns file for the bundle" null;
      bundleId = usrlib.mkStringOption "CFBundleIdentifier" "org.nix-darwin.apps.${lib.toLower (lib.replaceStrings [" "] ["-"] name)}";
    };
  });

  mkApp = name: app:
    let
      safe = lib.replaceStrings [ " " ] [ "-" ] name;
      cmd = if app.terminal then "${cfg.terminalCommand} ${lib.escapeShellArg app.command}" else app.command;
      launcher = pkgs.writeShellScript "${safe}-launcher" ''
        export PATH="$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
        ${cmd}
      '';
      plist = pkgs.writeText "${safe}-Info.plist" ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>CFBundleName</key><string>${name}</string>
          <key>CFBundleDisplayName</key><string>${name}</string>
          <key>CFBundleIdentifier</key><string>${app.bundleId}</string>
          <key>CFBundleVersion</key><string>1.0</string>
          <key>CFBundlePackageType</key><string>APPL</string>
          <key>CFBundleExecutable</key><string>launcher</string>
          ${lib.optionalString (app.icon != null) "<key>CFBundleIconFile</key><string>icon.icns</string>"}
          <key>LSMinimumSystemVersion</key><string>11.0</string>
        </dict>
        </plist>
      '';
    in pkgs.runCommandLocal "app-${safe}" { } ''
      app="$out/Applications/${name}.app/Contents"
      mkdir -p "$app/MacOS" "$app/Resources"
      cp ${plist} "$app/Info.plist"
      cp ${launcher} "$app/MacOS/launcher"
      ${lib.optionalString (app.icon != null) ''cp ${app.icon} "$app/Resources/icon.icns"''}
    '';

  # freerdp bridge: hosts flagged `app = true` get a "RDP <name>" app. The
  # password is read from the login Keychain (service "rdp-<name>", account =
  # user); with no entry the session opens in the terminal so freerdp can
  # prompt. Add one with:
  #   security add-generic-password -s rdp-<name> -a <user> -w
  # NOTE: /p: puts the password on argv, visible in `ps` while the session runs.
  rdpApps = lib.mapAttrs' (name: h:
    let
      base = lib.concatStringsSep " " (
        [ "${rdp.package}/bin/sdl-freerdp" "/v:${h.host}" ]
        ++ lib.optional (h.user != null) "/u:${h.user}"
        ++ lib.optional (h.domain != null) "/d:${h.domain}"
        ++ lib.optionals h.useDefaultArgs rdp.defaultArgs
        ++ h.extraArgs
      );
    in lib.nameValuePair "RDP ${name}" {
      command = ''
        pw="$(/usr/bin/security find-generic-password -s ${lib.escapeShellArg "rdp-${name}"} ${lib.optionalString (h.user != null) "-a ${lib.escapeShellArg h.user}"} -w 2>/dev/null || true)"
        if [ -n "$pw" ]; then
          exec ${base} /p:"$pw"
        else
          exec ${cfg.terminalCommand} ${lib.escapeShellArg base}
        fi
      '';
    }
  ) (lib.filterAttrs (_: h: h.app) rdp.hosts);
in {
  options.nixtype.apps = {
    enable = usrlib.mkEnableOptionTrue "Build dockable .app bundles from `nixtype.apps.apps`";
    terminalCommand = usrlib.mkStringOption
      "Command prefix that runs its (single, quoted) argument as a shell snippet in a terminal window"
      "open -na Ghostty.app --args -e /bin/bash -lc";
    apps = lib.mkOption {
      type = lib.types.attrsOf appOption;
      default = { };
      example = lib.literalExpression ''
        {
          "Zellij" = { command = "zellij"; terminal = true; };
        }
      '';
      description = "Apps to build, keyed by bundle display name";
    };
  };

  config = lib.mkIf cfg.enable {
    nixtype.apps.apps = lib.mkIf (rdp.enable or false) rdpApps;
    home.packages = lib.mapAttrsToList mkApp cfg.apps;
  };
}

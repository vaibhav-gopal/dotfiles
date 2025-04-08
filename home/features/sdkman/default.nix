{ config, lib, ... }:

{
  # Set environment variable for SDKMAN base
  home.sessionVariables = {
    SDKMAN_DIR = "${config.home.homeDirectory}/.sdkman";
  };

  # Automatically install SDKMAN and a JDK on activation
  home.activation.installSdkman = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$SDKMAN_DIR" ]; then
      echo "⬇️ Installing SDKMAN..."
      curl -s "https://get.sdkman.io" | bash
    fi

    export SDKMAN_DIR="$SDKMAN_DIR"
    [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

    # Install Adoptium Temurin JDK if not already present
    if ! sdk list java | grep -q 'tem'; then
      echo "⬇️ Installing Adoptium (Temurin) JDK via SDKMAN..."
      sdk install java temurin
    fi
  '';
}


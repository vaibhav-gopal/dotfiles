{ config, lib, ... }:

{
  # Set environment variable for NVM location
  home.sessionVariables = {
    NVM_DIR = "${config.home.homeDirectory}/.nvm";
  };

  # Automatically install NVM and latest Node on activation
  home.activation.installNvm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$NVM_DIR" ]; then
      echo "⬇️ Installing NVM..."
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    fi

    # Load NVM temporarily in this shell
    export NVM_DIR="$NVM_DIR"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

    # Install latest Node.js if not already
    if ! nvm ls | grep -q '->'; then
      echo "⬇️ Installing latest Node.js with NVM..."
      nvm install node
    fi
  '';
}

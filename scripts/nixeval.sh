#!/usr/bin/env bash

# Function to evaluate nix configuration attributes
# Usage: nix_eval <config_path> <attribute_path>
# Example: nix_eval "/path/to/config" "core"
nix_eval() {
  local config_path="$1"
  local attr_path="$2"

  if [[ -z "$config_path" ]] || [[ -z "$attr_path" ]]; then
    echo "Error: nix_eval requires config_path and attr_path" >&2
    return 1
  fi

  sudo -H nix eval --json "$config_path.$attr_path"
}

export -f nix_eval

# Function to evaluate nix options with their metadata
# Usage: nix_eval_options <config_path> <attribute_path>
# Example: nix_eval_options "/path/to/config" "core"
# Returns JSON with type, description, default, and current value for each option
nix_eval_options() {
  local config_path="$1"
  local attr_path="$2"

  if [[ -z "$config_path" ]] || [[ -z "$attr_path" ]]; then
    echo "Error: nix_eval_options requires config_path and attr_path" >&2
    return 1
  fi

  sudo -H nix eval \
    --json \
    "$config_path.$attr_path" \
    --apply \
    "let
        # Helper to turn any Nix value into a JSON-safe string
        forceString = v:
            if builtins.isBool v then (if v then \"true\" else \"false\")
            else if v == null then \"null\"
            else if builtins.isFunction v then \"<function>\"
            else if builtins.isList v then \"[list]\"
            else builtins.toString v;

        # Recursive function to traverse the option tree
        f = set: builtins.mapAttrs (n: v:
            if v ? _type && v._type == \"option\"
            then {
            type = v.type.description or \"unknown\";
            description = v.description or \"no description\";
            default = if v ? default then forceString v.default else \"no default\";
            value = if v ? value then forceString v.value else \"not set\";
            }
            else f v
        ) set;
    in f" | jq
}

export -f nix_eval_options
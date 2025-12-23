{ lib }:
{
  mkOptionEnableTrue = desc: lib.mkEnableOption desc // { default = true; };
  mkOptionEnableFalse = desc: lib.mkEnableOption desc // { default = false; };
  mkOptionString = desc: default: lib.mkOption {
    type = lib.types.str;
    default = default;
    description = desc;
  };
  mkOptionLines = desc: default: lib.mkOption {
    default = default;
    type = lib.types.lines;
    description = desc;
  };
  mkOptionPath = desc: default: lib.mkOption {
    type = lib.types.path;
    default = default;
    description = desc;
  };
  mkOptionPackage = desc: default: lib.mkOption {
    type = lib.types.package;
    default = default;
    description = desc;
  };
  mkOptionAttrs = desc: default: lib.mkOption {
    default = default;
    type = lib.types.attrsOf lib.types.anything;
    description = desc;
  };
  mkOptionEnum = desc: default: list: lib.mkOption {
    type = lib.types.enum list;
    default = default;
    description = desc;
  };
  mkOptionListOfEnum = desc: default: list: lib.mkOption {
    type = lib.types.listOf (lib.types.enum list);
    default = default;
    description = desc;
  };
}
{ lib }:
{
  _module.args.usrlib = {
    mkEnableOptionTrue = desc: lib.mkEnableOption desc // { default = true; };
    mkEnableOptionFalse = desc: lib.mkEnableOption desc // { default = false; };
    mkStringOption = desc: default: lib.mkOption {
      type = lib.types.str;
      default = default;
      description = desc;
    };
    mkLinesOption = desc: default: lib.mkOption {
      default = default;
      type = lib.types.lines;
      description = desc;
    };
    mkPathOption = desc: default: lib.mkOption {
      type = lib.types.path;
      default = default;
      description = desc;
    };
    mkPackageOption = desc: default: lib.mkOption {
      type = lib.types.package;
      default = default;
      description = desc;
    };
    mkAttrsOption = desc: default: lib.mkOption {
      default = default;
      type = lib.types.attrsOf lib.types.anything;
      description = desc;
    };
    mkEnumOption = desc: default: list: lib.mkOption {
      type = lib.types.enum list;
      default = default;
      description = desc;
    };
    mkListOfEnumOption = desc: default: list: lib.mkOption {
      type = lib.types.listOf (lib.types.enum list);
      default = default;
      description = desc;
    };
    mkListOfPackagesOption = desc: default: lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = default;
      description = desc;
    };
    mkNullOrPackageOption = desc: default: lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = default;
      description = desc;
    };
  };
}
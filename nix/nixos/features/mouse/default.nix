{ config, lib, pkgs, nixType, ... }:
let
  cfg = config.${nixType}.mouse;
in {
  options.${nixType}.mouse = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable a mouse remapper + dpi management tool";
    };
				package = lib.mkOption {
						type = lib.types.package;
						default = pkgs.solaar;
						defaultText = lib.literalExpression "pkgs.solaar";
						description = "The mouse remapper tool to use";
				};
  };

  config = lib.mkIf cfg.enable {
				environment.systemPackages = [ pkgs.package ];
  };
}

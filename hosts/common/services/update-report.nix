{ config
, lib
, pkgs
, user
, ...
}:
with lib; let
  cfg = config.common.services.update-report;
in
{
  options.common.services.update-report.enable = mkEnableOption "enable report after a rebuild";

  config = mkIf cfg.enable {
    system.activationScripts.diff = ''
      if [[ -e /run/current-system ]]; then
      ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
      fi
    '';
  };
}

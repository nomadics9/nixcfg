{ config
, lib
, ...
}:
with lib; let
  cfg = config.common.services.steam;
in
{
  options.common.services.steam.enable = mkEnableOption "enable steam";

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
  };
}

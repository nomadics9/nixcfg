{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.common.services.polkit;
in
{
  options.common.services.polkit.enable = mkEnableOption "Polkit Auth Agent";

  config = mkIf cfg.enable
    {

      systemd = {
        user.services.polkit-gnome-authentication-agent-1 = {
          description = "polkit-gnome-authentication-agent-1";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };
    };
}

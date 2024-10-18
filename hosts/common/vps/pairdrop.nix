{ config, lib, pkgs, ... }:
with lib;

let
  pairdropService = {
    project.name = "pairdrop";
    services = {
      pairdrop = {
        service = {
          image = "lscr.io/linuxserver/pairdrop:latest";
          environment = {
            PUID = "1000"; # User ID
            PGID = "1000"; # Group ID
            TZ = "Asia/Kuwait"; # Time zone
            RATE_LIMIT = "false"; # Optional
            WS_FALLBACK = "false"; # Optional
            RTC_CONFIG = ""; # Optional
            DEBUG_MODE = "false"; # Optional
          };
          ports = [
            "3000:3000"
          ];
          restart = "unless-stopped";
        };
      };
    };
  };
in
{
  options.vps.pairdrop.enable = mkEnableOption "Enable Pairdrop service";

  config = mkIf config.vps.pairdrop.enable {
    virtualisation.arion = {
      backend = "docker";
      projects.pairdrop = {
        serviceName = "pairdrop";
        settings = pairdropService;
      };
    };
  };
}


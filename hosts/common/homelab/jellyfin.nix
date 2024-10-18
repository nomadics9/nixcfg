{ config, lib, pkgs, ... }:
with lib;

let
  jellyfinServices = {
    jellyfin = {
      image = "nomadics/alaskarfin:latest";
      container_name = "jellyfin";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Asia/Kuwait";
      };
      volumes = [
        "/home/${user}/configs/jellyfin_config:/config"
        "/home/${user}/media/tvshows:/data/tvshows"
        "/home/${user}/media/movies:/data/movies"
      ];
      ports = [ "8096:8096" ];
      restart = "unless-stopped";
    };

    jellyseerr = {
      image = "nomadics/alaskarseer:latest";
      container_name = "jellyseerr";
      environment = {
        PUID = "1000";
        PGID = "1000";
        LOG_LEVEL = "debug";
        TZ = "Asia/Kuwait";
        JELLYFIN_TYPE = "jellyfin";
      };
      networks = [ "jellyfin" ];
      ports = [ "5055:5055" ];
      volumes = [ "/home/${user}/configs/jellyseerr_config:/app/config" ];
      restart = "unless-stopped";
      depends_on = [
        "radarr"
        "sonarr"
      ];
    };
    networks = [ "jellyfin" ];
  };
in
{
  options.services.jellyfin-server.enable = mkEnableOption "Enable Jellyfin stack";

  config = mkIf config.services.jellyfin-server.enable {
    virtualisation.arion = {
      backend = "docker";
      projects.dufs = {
        serviceName = "jellyfin";
        settings = jellyfinServices;
      };
    };
  };
}

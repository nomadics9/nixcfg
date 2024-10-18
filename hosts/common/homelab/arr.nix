{ config, lib, pkgs, user, ... }:
with lib;

let

  arrServices = {
    prowlarr = {
      image = "ghcr.io/hotio/prowlarr";
      container_name = "prowlarr";
      environment = {
        PUID = "1000";
        PGID = "1000";
        UMASK = "002";
        TZ = "Asia/Kuwait";
      };
      volumes = [ "/home/${user}/configs/prowlarr_config:/config" ];
      ports = [ "9696:9696" ];
      restart = "unless-stopped";
    };

    sonarr = {
      image = "linuxserver/sonarr:latest";
      container_name = "sonarr";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Asia/Kuwait";
      };
      volumes = [
        "/home/${user}/configs/sonarr_config:/config"
        "/home/${user}/media/tvshows:/tvshows"
        "/home/${user}/media/anime:/anime"
        "/home/${user}/media/transmission/downloads/complete:/downloads/complete"
      ];
      ports = [ "8989:8989" ];
      restart = "unless-stopped";
    };

    radarr = {
      image = "linuxserver/radarr:latest";
      container_name = "radarr";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Asia/Kuwait";
      };
      networks = [ "jellyfin" ];
      volumes = [
        "/home/${user}/configs/radarr_config:/config"
        "/home/${user}/media/movies:/movies"
        "/home/${user}/media/transmission/downloads/complete:/downloads/complete"
      ];
      ports = [ "7878:7878" ];
      restart = "unless-stopped";
    };

    readarr = {
      image = "lscr.io/linuxserver/readarr:develop";
      container_name = "readarr";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Asia/Kuwait";
      };
      networks = [ "jellyfin" ];
      volumes = [
        "/home/${user}/configs/readarr_config:/config"
        "/home/${user}/media/books:/books"
        "/home/${user}/media/transmission/downloads/complete:/downloads/complete"
      ];
      ports = [ "8787:8787" ];
      restart = "unless-stopped";
    };

    bazarr = {
      image = "linuxserver/bazarr";
      container_name = "bazarr";
      environment = {
        DOCKER_MODS = "wayller/bazarr-mod-subsync:latest";
        PUID = "1000";
        PGID = "1000";
        TZ = "Asia/Kuwait";
      };
      networks = [ "jellyfin" ];
      volumes = [
        "/home/${user}/configs/bazarr_config:/config"
        "/home/${user}/media/tvshows:/tvshows"
        "/home/${user}/media/movies:/movies"
        "/home/${user}/media/anime:/anime"
      ];
      ports = [ "6767:6767" ];
      restart = "unless-stopped";
    };

    networks = [ "jellyfin" ];

  };
in
{
  options.services.arr.enable = mkEnableOption "Enable ARR services stack";

  config = mkIf config.services.arr.enable {
    virtualisation.arion = {
      backend = "docker";
      projects.dufs = {
        serviceName = "arr";
        settings = arrServices;
      };
    };
  };
}

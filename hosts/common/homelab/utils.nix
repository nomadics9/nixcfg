{ config, lib, pkgs, user, ... }:
with lib;

let
  utilsServices = {
    jellystat = {
      image = "cyfershepard/jellystat:unstable";
      container_name = "jellystat";
      environment = {
        POSTGRES_USER = "postgres";
        POSTGRES_PASSWORD = "serverstat";
        TZ = "Asia/Kuwait";
      };
      volumes = [ "/home/${user}/configs/jellystat-backup-data:/app/backend/backup-data" ];
      ports = [ "3000:3000" ];
      restart = "unless-stopped";
    };

    jellystat-db = {
      container_name = "jellystat-db";
      image = "postgres:15.2";
      environment = {
        POSTGRES_DB = "jfstat";
        POSTGRES_USER = "postgres";
        POSTGRES_PASSWORD = "serverstat";
        TZ = "Asia/Kuwait";
      };
      restart = "unless-stopped";
      volumes = [
        "/home/${user}/configs/postgres-data:/var/lib/postgresql/data" # Mounting the volume
      ];
    };

    jfa-go = {
      container_name = "jfa-go";
      image = "hrfee/jfa-go:latest";
      restart = "unless-stopped";
      volumes = [
        "/home/${user}/configs/jfa-go_config/jfa-go:/data"
        "/home/sager/stream-stack/jellyfin_config:/jf"
        "/etc/localtime:/etc/localtime:ro"
      ];
      ports = [
        "8056:8056"
      ];
    };


    image = "golift/unpackerr";
    container_name = "unpackerr";
    volumes = [
      "/home/${user}/media/transmission/downloads:/downloads"
    ];
    restart = "always";
    user = "1000:1000";
    environment = {
      TZ = "Asia/Kuwait";
      UN_DEBUG = "false";
      UN_LOG_FILE = "";
      UN_LOG_FILES = "10";
      UN_LOG_FILE_MB = "10";
      UN_INTERVAL = "2m";
      UN_START_DELAY = "1m";
      UN_RETRY_DELAY = "5m";
      UN_MAX_RETRIES = "3";
      UN_PARALLEL = "1";
      UN_FILE_MODE = "0644";
      UN_DIR_MODE = "0755";

      # Sonarr Config
      UN_SONARR_0_URL = "http://192.168.0.200:8989";
      UN_SONARR_0_API_KEY = "ece789601b4541be934324cc5c338092";
      UN_SONARR_0_PATHS_0 = "/downloads";
      UN_SONARR_0_PROTOCOLS = "torrent";
      UN_SONARR_0_TIMEOUT = "10s";
      UN_SONARR_0_DELETE_ORIG = "false";
      UN_SONARR_0_DELETE_DELAY = "5m";

      # Radarr Config
      UN_RADARR_0_URL = "http://192.168.0.200:7878";
      UN_RADARR_0_API_KEY = "446ab739173c4cb1b2c52eb1f3000f50";
      UN_RADARR_0_PATHS_0 = "/downloads";
      UN_RADARR_0_PROTOCOLS = "torrent";
      UN_RADARR_0_TIMEOUT = "10s";
      UN_RADARR_0_DELETE_ORIG = "false";
      UN_RADARR_0_DELETE_DELAY = "5m";

      # UN_READARR_0_URL = "http://readarr:8787";
      # UN_READARR_0_API_KEY = "";
      # UN_READARR_0_PATHS_0 = "/downloads";
      # UN_READARR_0_PROTOCOLS = "torrent";
      # UN_READARR_0_TIMEOUT = "10s";
      # UN_READARR_0_DELETE_ORIG = "false";
      # UN_READARR_0_DELETE_DELAY = "5m";
    };
    security_opt = [ "no-new-privileges:true" ];

  };
in
{
  options.services.utils.enable = mkEnableOption "Enable Utils services stack";

  config = mkIf config.services.utils.enable {
    virtualisation.arion = {
      backend = "docker"; # Or "podman" if you use Podman
      projects.dufs = {
        serviceName = "utils";
        settings = utilsServices;
      };
    };
  };
}

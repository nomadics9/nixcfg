{ config, lib, pkgs, user, ... }:
with lib;

let
  nextcloudService = {
    project.name = "nextcloud";
    services = {
      nextcloud = {
        service = {
          image = "lscr.io/linuxserver/nextcloud:latest";
          environment = {
            PUID = "1000"; # User ID
            PGID = "1000"; # Group ID
            TZ = "Asia/Kuwait"; # Time zone
          };
          volumes = [
            "/home/${user}/dockers/nextcloud/config:/config" # Config path
            "/home/${user}/dockers/nextcloud/data:/data" # Data path
            "/home/${user}/dockers/nextcloud/postgres_data:/var/lib/postgresql/data" # PostgreSQL data path
          ];
          ports = [
            "4400:443"
          ];
          restart = "unless-stopped";
          networks = [ "nextcloud_network" ];
          env_file = [ "${config.sops.templates."my-env.env".path}" ];
        };
      };
      nextcloud-postgres = {
        service = {
          image = "postgres:latest";
          environment = {
            POSTGRES_USER = "$NEXTCLOUD_DB_USER";
            POSTGRES_PASSWORD = "$NEXTCLOUD_DB_PASSWORD";
            POSTGRES_DB = "$NEXTCLOUD_DB";
          };
          ports = [
            "5432:5432"
          ];
          volumes = [
            "/home/${user}/dockers/nextcloud/pgdata:/var/lib/postgresql/data"
          ];
          env_file = [ "${config.sops.templates."my-env.env".path}" ]; #idk why the image isnt reading this file. will fix later
          networks = [ "nextcloud_network" ];
        };
      };
    };
  };
in
{
  options.vps.nextcloud.enable = mkEnableOption "Enable Nextcloud service for VPS";

  config = mkIf config.vps.nextcloud.enable {
    virtualisation.arion = {
      backend = "docker";
      projects.nextcloud = {
        serviceName = "nextcloud";
        settings = nextcloudService;
      };
    };
  };
}


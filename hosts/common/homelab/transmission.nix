{ config, lib, pkgs, ... }:
with lib;

let
  transmissionServices = {
    transmission = {
      image = "linuxserver/transmission:latest";
      container_name = "transmission";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Asia/Kuwait";
      };
      volumes = [
        "/home/${user}/configs/transmission_config:/config"
        "/home/${user}/media/transmission/downloads:/downloads"
      ];
      ports = [
        "9091:9091"
        "51413:51413"
        "51413:51413/udp"
      ];
      restart = "unless-stopped";
    };
  };
in
{
  options.services.downloader.enable = mkEnableOption "Enable Transmission service";

  config = mkIf config.services.downloader.enable {
    virtualisation.arion = {
      backend = "docker"; # Or "podman" if you use Podman
      projects.dufs = {
        serviceName = "transmission";
        settings = transmissionServices;
      };
    };
  };
}

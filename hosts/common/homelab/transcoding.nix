{ config, lib, pkgs, ... }:
with lib;

let
  transcodingServices = {
    tdarr = {
      image = "ghcr.io/haveagitgat/tdarr:latest";
      container_name = "tdarr";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Asia/Kuwait";
        NVIDIA_VISIBLE_DEVICES = "all";
      };
      volumes = [
        "/home/${user}/configs/tdarr_config:/config"
        "/home/${user}/media:/media"
      ];
      ports = [
        "8265:8265"
        "8266:8266"
      ];
      restart = "unless-stopped";
    };
  };
in
{
  options.services.transcoding.enable = mkEnableOption "Enable transcoding stack";

  config = mkIf config.services.transcoding.enable {
    virtualisation.arion = {
      backend = "docker"; # Or "podman" if you use Podman
      projects.dufs = {
        serviceName = "transcoding";
        settings = transcodingServices;
      };
    };
  };
}

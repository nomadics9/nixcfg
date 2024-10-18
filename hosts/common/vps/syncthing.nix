{ config, lib, pkgs, user, ... }:
with lib;

let
  syncthingService = {
    project.name = "syncthing";
    services = {
      syncthing = {
        service = {
          image = "syncthing/syncthing:latest";
          hostname = "NixOS-syncthing";
          environment = {
            PUID = "1000"; # User ID
            PGID = "1000"; # Group ID
          };
          volumes = [
            "/home/${user}/dockers/syncthing:/var/syncthing" # Adjust the path as necessary
          ];
          ports = [
            "8384:8384" # Web UI
            "22000:22000/tcp" # TCP file transfers
            "22000:22000/udp" # QUIC file transfers
            "21027:21027/udp" # Receive local discovery broadcasts
          ];
          restart = "unless-stopped";
        };
      };
    };
  };
in
{
  options.vps.syncthing.enable = mkEnableOption "Enable Syncthing service on VPS";

  config = mkIf config.vps.syncthing.enable {
    virtualisation.arion = {
      backend = "docker";
      projects.syncthing = {
        serviceName = "syncthing";
        settings = syncthingService;
      };
    };
  };
}


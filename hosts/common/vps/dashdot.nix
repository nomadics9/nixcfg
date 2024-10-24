{ config, lib, pkgs, user, ... }:
with lib;

let
  dashdotService = {
    project.name = "dashdot";
    services = {
      dashdot = {
        service = {
          image = "mauricenino/dashdot:latest";
          restart = "unless-stopped";
          privileged = true;
          ports = [
            "19999:3001"
          ];
          volumes = [
            "/:/mnt/host:ro"
          ];
          environment = {
            DASHDOT_PAGE_TITLE = "Nomadics VPS";
            DASHDOT_ALWAYS_SHOW_PERCENTAGES = "true";
          };
        };
      };
    };
  };
in
{
  options.vps.dashdot.enable = mkEnableOption "Enable dashdot dashboard for VPS";

  config = mkIf config.vps.dashdot.enable {
    virtualisation.arion = {
      backend = "docker";
      projects.dashdot = {
        serviceName = "dashdot";
        settings = dashdotService;
      };
    };
  };
}



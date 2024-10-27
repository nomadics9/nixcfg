{ config, lib, pkgs, user, ... }:
with lib;

let
  audiobookshelfService = {
    project.name = "audiobookshelf";
    services = {
      dashdot = {
        service = {
          image = "ghcr.io/advplyr/audiobookshelf:latest";
          ports = [
            "13378:80"
          ];
          volumes = [
            "${config.users.users.${user}.home}/dockers/audiobookshelf/audiobooks:/audiobooks"
            "${config.users.users.${user}.home}/dockers/audiobookshelf/podcasts:/podcasts"
            "${config.users.users.${user}.home}/dockers/audiobookshelf/config:/config"
            "${config.users.users.${user}.home}/dockers/audiobookshelf/metadata:/metadata"
          ];
          environment = {
            TZ = "Asia/Kuwait";
          };
        };
      };
    };
  };
in
{
  options.vps.audiobookshelf.enable = mkEnableOption "Enable audiobookshelf for VPS";

  config = mkIf config.vps.audiobookshelf.enable {
    virtualisation.arion = {
      backend = "docker";
      projects.audiobookshelf = {
        serviceName = "audiobookshelf";
        settings = audiobookshelfService;
      };
    };
  };
}



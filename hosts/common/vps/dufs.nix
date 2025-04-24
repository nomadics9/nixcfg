{ config, lib, pkgs, user, ... }:
with lib;
let
  dufsService = {
    project.name = "dufs";
    services = {
      dufs = {
        service.image = "sigoden/dufs:latest";
        service.ports = [
          "5000:5000"
        ];
        service.volumes = [
          "${config.users.users.${user}.home}/dockers/dufs/data:/data"
        ];
        service.command = [
          "/data"
          "-a"
          ''asdfas@/:rw'' # till i figure out how to pass the damn env
          "-A"
          "-a"
          "@/p:rw"
        ];
        service.env_file = [ "${config.sops.templates."my-env.env".path}" ];

      };
    };
  };
in
{
  options.vps.dufs.enable = mkEnableOption " Enable DUFS service ";

  config = mkIf config.vps.dufs.enable {
    virtualisation.arion = {
      backend = "docker";
      projects.dufs = {
        serviceName = "dufs";
        settings = dufsService;
      };
    };
  };
}




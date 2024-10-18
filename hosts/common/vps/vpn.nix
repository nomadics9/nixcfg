{ config, lib, pkgs, user, ... }:
with lib;

let
  wgEasyService = {
    project.name = "vpn";
    services = {
      wgEasy = {
        service = {
          image = "ghcr.io/wg-easy/wg-easy:latest";
          environment = {
            LANG = "en";
            WG_HOST = "vpn.nmd.mov"; # Change to your host's public address
            PASSWORD_HASH = "$$2a$$12$$fnnv.bDGodZEiIK4wBxA8u2K2Qc99BCjD72jmylBFooFEVFgtQ2ma"; # Replace with your hash
            PORT = "51821";
            WG_DEFAULT_DNS = "1.1.1.1";
            UI_TRAFFIC_STATS = "true";
            UI_CHART_TYPE = "1"; # Line chart
            UI_ENABLE_SORT_CLIENTS = "true";
          };
          volumes = [
            "/home/${user}/dockers/wg-easy/etc_wireguard:/etc/wireguard" # Adjust the path as necessary
          ];
          ports = [
            "51820:51820/udp"
            "51821:51821/tcp"
          ];
          restart = "unless-stopped";
          capabilities = {
            NET_ADMIN = true;
            SYS_MODULE = true;
            # "NET_RAW" # Uncomment if using Podman
          };
          sysctls = {
            "net.ipv4.ip_forward" = 1;
            "net.ipv4.conf.all.src_valid_mark" = 1;
          };
        };
      };
    };
  };
in
{
  options.vps.vpn.enable = mkEnableOption "Enable WG-Easy service on VPS";

  config = mkIf config.vps.vpn.enable {
    virtualisation.arion = {
      backend = "docker";
      projects.vpn = {
        serviceName = "vpn";
        settings = wgEasyService;
      };
    };
  };
}


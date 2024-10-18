{ pkgs, hostname, user, lib, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  hardware.disko.enable = true;

  programs.nix-ld.enable = true;
  common.services.appimage.enable = true;


  systemd.services.arion = {
    enable = true;
    serviceConfig = {
      Restart = "on-failure";
    };
  };

  vps = {
    dufs.enable = true;
    nextcloud.enable = false;
    pairdrop.enable = true;
    syncthing.enable = true;
    vpn.enable = true;
  };

  sops = {
    age.keyFile = "/etc/nixos/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  services.caddy = {
    enable = true;
    logDir = "/var/log/caddy";

    # Configure log format using mkForce to make sure it takes effect
    logFormat = lib.mkForce ''
      level INFO
      output file /var/log/caddy/access.log {
        roll_size 50mb
        roll_keep 5
        roll_keep_for 720h
      }
      format json
    '';

    # Reverse proxy configuration for each domain
    extraConfig = ''
      fs.nmd.mov {
        reverse_proxy localhost:5000
        log
      }

      vpn.nmd.mov {
        reverse_proxy localhost:51821
        log
      }

      s.nmd.mov {
        reverse_proxy localhost:8384
        log
      }

      drop.nmd.mov {
        reverse_proxy localhost:3000
        log
      }

      dot.nmd.mov {
        reverse_proxy localhost:19999
        log

        basic_auth /* {
          nomad $2a$12$toBh5sfXyxigtHGNY4t8tO7YYQp6i3aZk/O0qd19lgk0LRz5eqDVi
        }
      }
    '';
  };
  services.netdata = {
    enable = true;
    package = pkgs.netdata.override {
      withCloudUi = true;
    };
    extraPluginPaths = [ "/etc/netdata/custom-plugins.d" ];
    configDir = {
      # Add the custom plugin script to the Netdata configuration directory
      "plugins.d/caddy_visitors.sh" = pkgs.writeText "caddy_visitors.sh" ''
        #!/bin/env/sh

        # Path to the Caddy JSON access log file
        log_file="/var/log/caddy/access.log"

        # Extract unique visitor IPs from JSON log file
        unique_visitors=$(jq -r "select(.request.remote_ip != null) | .request.remote_ip" "$log_file" | sort | uniq | wc -l)

        # Define the chart
        echo CHART caddy_visitors.unique_ips "Unique Visitors from Caddy Logs" "IPs" "Caddy Logs" caddy_visitors line $((netdata_update_every * 10)) 1
        echo DIMENSION unique_visitors "" absolute 1 1

        # Output the result in a format that Netdata understands
        echo BEGIN caddy_visitors.unique_ips
        echo SET unique_visitors = $unique_visitors
        echo END
      '';
    };
  };



  networking.useDHCP = lib.mkForce false;
  services.cloud-init = {
    enable = true;
    network.enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };



  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };



  networking.hostName = "vps";




  time.timeZone = "Asia/Kuwait";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };


  services.printing.enable = false;

  nixpkgs.config.allowUnfree = true;


  environment.systemPackages = with pkgs; [
    neovim
    git
    zsh
    arion
    sops
    jq
  ];


  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
    5000
    4400
    3000
    8384
    22000
    51821
  ];
  networking.firewall.allowedUDPPorts = [
    22000
    21027
    51820
  ];
  networking.firewall.extraCommands = ''
    # Allow access to port 19999 from localhost
    iptables -A INPUT -p tcp -s 127.0.0.1 --dport 19999 -j ACCEPT
    # Block all other access to port 19999
    iptables -A INPUT -p tcp --dport 19999 -j DROP
  '';
  system.stateVersion = "24.05";

}

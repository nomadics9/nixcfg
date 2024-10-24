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
    dashdot.enable = true;
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
    '';

    # Reverse proxy configuration for each domain
    extraConfig = ''
        (logging) {
            log {
              output file /var/log/caddy/{args[0]}.log {
              roll_size 50mb
              roll_keep 5
              roll_keep_for 720h
              }
            }
        }

        fs.nmd.mov {
          reverse_proxy localhost:5000
          import logging fs
        }

        vpn.nmd.mov {
          reverse_proxy localhost:51821
          import logging vpn
        }

        s.nmd.mov {
          reverse_proxy localhost:8384
          import logging s
        }

        drop.nmd.mov {
          reverse_proxy localhost:3000
          import logging drop
        }

        dot.nmd.mov {
          reverse_proxy localhost:19999

          basic_auth /* {
            nomad $2a$12$toBh5sfXyxigtHGNY4t8tO7YYQp6i3aZk/O0qd19lgk0LRz5eqDVi
          }
        }

        dash.nmd.mov {
          reverse_proxy localhost:8080
        }


          nmd.mov {
            root * /var/www/goaccess

            file_server

      reverse_proxy /ws_fs localhost:7890
      reverse_proxy /ws_drop localhost:7891
      reverse_proxy /ws_vpn localhost:7892
      reverse_proxy /ws_sync localhost:7893

          basic_auth /* {
            nomad $2a$12$toBh5sfXyxigtHGNY4t8tO7YYQp6i3aZk/O0qd19lgk0LRz5eqDVi
          }

        }
    '';
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

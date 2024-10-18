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
    extraConfig = ''
      fs.nmd.mov {
        reverse_proxy localhost:5000
      }
      vpn.nmd.mov {
        reverse_proxy localhost:51821
      }
      s.nmd.mov {
        reverse_proxy localhost:8384
      }
      drop.nmd.mov {
        reverse_proxy localhost:3000
      } 
      dot.nmd.mov {
        reverse_proxy localhost:4400
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
  ];


  networking.firewall.enable = false;
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
  system.stateVersion = "24.05";

}

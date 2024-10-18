{ pkgs, hostname, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  hardware.nvidia.enable = true;
  hardware.disko.enable = true;


  programs.nix-ld.enable = true;
  common.services.appimage.enable = true;

  systemd.services.arion = {
    enable = true;
    serviceConfig = {
      Restart = "on-failure";
    };
  };

  services = {
    arr.enable = true;
    jellyfin.enable = true;
    transcoding.enable = true;
    transmission.enable = true;
    utils.enable = true;
  };

  sops = {
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.supportedFilesystems = [ "ntfs" ];



  networking.hostName = "Homelab";
  networking.networkmanager.enable = true;


  hardware.pulseaudio.enable = false;
  security.rtkit.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


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

  services.xserver = {
    exportConfiguration = true;
    xkb.layout = "us,ara";
    xkb.options = "grp:alt_shift_toggle";
    xkb.variant = "qwerty_digits";
  };

  services.printing.enable = true;

  nixpkgs.config.allowUnfree = true;


  environment.systemPackages = with pkgs; [
    neovim
    git
    zsh
  ];


  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    9696
    8989
    7878
    8787
    6767
    8096
    5055
    8265
    8266
    9091
    51413
    3000
    8056
  ];

  system.stateVersion = "24.05";
}

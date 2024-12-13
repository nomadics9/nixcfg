{ pkgs, hostname, inputs, user, ... }: {

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Hardware
  # Nvidia
  hardware.nvidia.enable = true;
  # Battery
  hardware.battery.enable = true;

  # Common
  # System
  common.services.polkit.enable = true;
  common.services.xdgportal.enable = true;
  common.services.update-report.enable = true;
  programs.nix-ld.enable = true; # Non nixos binaries such as mason LSPs
  # Filemanager
  common.services.nautilus.enable = true;
  # Virtual Box (Virt-Manager) and GPU Passthru. you have to configure hosts/services/vfio.nix for passthrough to work!
  common.services.vm.enable = true;
  #common.services.vfio.enable = false;
  # AppStores
  common.services.appimage.enable = true;
  common.services.steam.enable = true;
  services.flatpak.enable = true;

  # Sops secrets Comment this out if you dont need secrets! and configure ur user in hosts/common/users/YOURUSERNAME.nix
  sops = {
    age.keyFile = "/etc/nixos/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  #services.samba.enable = true;


  #Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  #Boot entries limit
  boot.loader.systemd-boot.configurationLimit = 3;
  # Ntfs support
  boot.supportedFilesystems = [ "ntfs" ];


  # Enable GDM Login Manager
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
    banner = "Nomadic Nixos";
    autoSuspend = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  #Network
  #Define your hostname
  networking.hostName = "${hostname}";
  # Enable networking
  networking.networkmanager.enable = true;

  #Hosts 
  networking.extraHosts = ''
    10.10.11.45 vintage.htb DC01.vintage.htb
    10.10.11.25 greenhorn.htb
    10.10.11.31 infiltrator.htb
    10.10.11.32 sightless.htb
  '';

  # Bluethooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };


  # Set your time zone.
  #time.timeZone = "Asia/Kuwait";
  services.ntp = {
    enable = true;
  };
  # Select internationalisation properties.
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

  # Keyboard
  services.xserver = {
    exportConfiguration = true; # link /usr/share/X11/ properly
    xkb.layout = "us,ara";
    xkb.options = "grp:alt_shift_toggle";
    xkb.variant = "qwerty_digits";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.tapping = true; #tap


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    neovim
    git
    zsh
  ];

  #Firewall
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # For Chromecast from chrome
  # networking.firewall.allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.nftables.enable = false;


  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

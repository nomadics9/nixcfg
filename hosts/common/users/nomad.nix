{ config
, pkgs
, inputs
, user
, ...
}: {
  users.users = {
    ${user} = {
      initialPassword = "4321";
      isNormalUser = true;
      shell = pkgs.fish;
      description = "${user}";
      extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
        "flatpak"
        "audio"
        "video"
        "plugdev"
        "input"
        "kvm"
        "qemu-libvirtd"
        "docker"
        "key"
        "wireshark"
      ];
      packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqA7j8hk3+k0b04eDxuoUakldqKrP0aatLm+CREjFJe" #SSH, YOU HAVE TO CHANGE THIS OR REMOVE IT
      ];
    };

    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqA7j8hk3+k0b04eDxuoUakldqKrP0aatLm+CREjFJe" #SSH, YOU HAVE TO CHANGE THIS OR REMOVE IT

      ];
      extraGroups = [ "key" ];
    };
  };

  #Decrypt the secrets file using sops-nix with age
  sops.secrets = {
    DUFS_USERNAME = { };
    DUFS_PASSWORD = { };
    NEXTCLOUD_DB_USERNAME = { };
    NEXTCLOUD_DB_PASSWORD = { };
    NEXTCLOUD_DB = { };
  };

  sops.templates."my-env.env".content = ''
    DUFS_USERNAME = "${config.sops.placeholder.DUFS_USERNAME}"
    DUFS_PASSWORD = "${config.sops.placeholder.DUFS_PASSWORD}"
    NEXTCLOUD_DB_USERNAME = "${config.sops.placeholder.NEXTCLOUD_DB_USERNAME}"
    NEXTCLOUD_DB_PASSWORD = "${config.sops.placeholder.NEXTCLOUD_DB_PASSWORD}"
    NEXTCLOUD_DB = "${config.sops.placeholder.NEXTCLOUD_DB}"
  '';

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # programs.zsh.enable = true;
  programs.fish.enable = true;
  home-manager.users.${user} =
    import ../../../home/${user}/${config.networking.hostName}.nix;
}

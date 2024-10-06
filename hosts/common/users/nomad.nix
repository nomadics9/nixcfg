{ config
, pkgs
, inputs
, user
, ...
}: {
  users.users.${user} = {
    initialPassword = "4321";
    isNormalUser = true;
    shell = pkgs.zsh;
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
    ];
    packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
  };
  programs.zsh.enable = true;
  home-manager.users.${user} =
    import ../../../home/${user}/${config.networking.hostName}.nix;
}

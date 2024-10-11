{ config
, lib
, pkgs
, user
, ...
}:
with lib; let
  cfg = config.common.services.vm;
in
{
  options.common.services.vm.enable = mkEnableOption "enable virtualization";

  config = mkIf cfg.enable {
    # Add user to libvirtd group
    users.users.${user}.extraGroups = [ "libvirtd" ];

    # Install necessary packages
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      adwaita-icon-theme
      virtiofsd
      #bridge-utils
    ];

    # Manage the virtualisation services
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
  };
}

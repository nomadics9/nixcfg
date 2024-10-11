{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.common.services.appimage;
in
{
  options.common.services.vfio.enable = mkEnableOption "enable GPU Passthrough with looking-glass";

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      looking-glass-client
      scream
    ];

    boot.initrd.availableKernelModules = [ "vfio-pci" "nvidia" ];
    boot.initrd.preDeviceCommands = ''
      DEVS="0000:01:00.0" # Set your GPU here
      for DEV in $DEVS; do
        echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
          done
          modprobe -i vfio-pci
    '';

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelParams = [ "intel_iommu=on" "pcie_aspm=off" ];
    boot.kernelModules = [ "kvm-intel" ]; #kvm-amd if AMD
    boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidiafb" "nvidia_drm" ];



    systemd.tmpfiles.rules = [
      "f /dev/shm/scream 0660 nomad qemu-libvirtd -" # your username
      "f /dev/shm/looking-glass 0660 nomad qemu-libvirtd -" # your username
    ];

    systemd.user.services.scream-ivshmem = {
      enable = true;
      description = "Scream IVSHMEM";
      serviceConfig = {
        ExecStart = "${pkgs.scream}/bin/scream-ivshmem-pulse /dev/shm/scream";
        Restart = "always";
      };
      wantedBy = [ "multi-user.target" ];
      requires = [ "pulseaudio.service" ];
    };
  };
}

{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.hardware.disko;
in
{
  options.hardware.disko.enable = mkEnableOption "disko harddrives";

  config = mkIf cfg.enable {
    disko.devices = {
      disk = {
        os_drive = {
          type = "disk";
          path = "/dev/sde"; # OS hard drive
          partitions = {
            ESP = {
              type = "EF00"; # EFI system partition type
              size = "512M"; # EFI partition size
              content = {
                type = "filesystem";
                format = "vfat"; # Filesystem type for EFI
                mountpoint = "/boot/efi"; # Mount point for EFI
              };
            };
            root = {
              size = "100%"; # Use remaining space for root partition
              content = {
                type = "filesystem";
                format = "ext4"; # Filesystem type for root
                mountpoint = "/"; # Root mount point
              };
            };
          };

          ssd_1 = {
            content = {
              type = "lvm";
              path = "/dev/vg-ssd/lv-ssd";
              mountPoint = "/home";
              #format = null; # Do not format, preserve data
            };
          };
        };
      };
    };
  };
}

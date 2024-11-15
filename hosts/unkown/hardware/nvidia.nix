{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.hardware.nvidia;
in
{
  options.hardware.nvidia.enable = mkEnableOption "nvidia driver";

  config = mkIf cfg.enable {
    #Allow unfree packages
    nixpkgs.config.allowUnfree = true;


    services.xserver = {
      videoDrivers = [ "nvidia" ];
    };

    hardware = {
      graphics.enable = true;
      # opengl.driSupport = true;
      graphics.enable32Bit = true;
      graphics = {
        extraPackages = with pkgs; [
          intel-media-driver # LIBVA_DRIVER_NAME=iHD
          # intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
          libvdpau-va-gl
          vaapiVdpau
          mesa.drivers
        ];
      };



      nvidia.nvidiaSettings = true;
      nvidia.powerManagement.enable = true;
      nvidia.powerManagement.finegrained = true;
      nvidia.open = false;
      # nvidia.forceFullCompositionPipeline = true;

      # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
      nvidia.modesetting.enable = true;
      #nvidia.nvidiaPersistenced = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

      #offload , Sync or reverseSync
      nvidia.prime = {
        # reSync Mode
        # reverseSync.enable = true;

        # Sync Mode
        # sync.enable = true;

        # Offload Mode
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:1:0:0";

        # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
        intelBusId = "PCI:0:2:0";
      };
    };


    # Nvidia in Docker
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      #enableNvidia = true;
    };

    hardware.nvidia-container-toolkit.enable = true;

    environment.systemPackages = with pkgs; [
      cudatoolkit
    ];
  };
}





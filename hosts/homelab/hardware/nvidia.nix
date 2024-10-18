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
          # libvdpau-va-gl
          # vaapiVdpau
          # mesa.drivers
        ];
      };


      nvidia.nvidiaSettings = true;
      nvidia.powerManagement.enable = false;
      nvidia.powerManagement.finegrained = false;
      nvidia.open = false;
      # nvidia.forceFullCompositionPipeline = true;

      # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
      nvidia.modesetting.enable = false;
      #nvidia.nvidiaPersistenced = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
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





{ config, lib, pkgs, user, ... }:

{
  home.username = lib.mkDefault user;
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    mullvad-vpn
    tailscale
    htop
    bun
    lua-language-server




  ];

  home.file = { };

  home.sessionVariables = {
    EDITOR = "nvim";
    GBM_BACKEND = "nvidia-drm";
    WLR_RENDERER = "vulkan";
    VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_BIN_HOME = "${config.home.homeDirectory}/.nix-profile/bin";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
  };

  programs.home-manager.enable = true;
}

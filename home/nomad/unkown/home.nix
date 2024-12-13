# This is a default home.nix generated by the follwing hone-manager command
# 
# home-manager init ./

{ config, lib, pkgs, user, inputs, ... }:

{
  home.username = lib.mkDefault user;
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Essentials
    kitty
    alacritty
    tmux
    firefox
    google-chrome
    age
    sops
    networkmanagerapplet
    nvd
    # Apps
    vlc
    amberol
    webcord
    bottles
    #cava
    ryujinx
    mullvad-vpn
    transmission_4-gtk
    obsidian
    tailscale
    syncthing
    qsyncthingtray
    htop
    openvpn
    #nvtopPackages.full
    exiftool
    moonlight-qt
    kdePackages.kdeconnect-kde
    cmatrix
    #jellyfin-media-player
    speedtest-go
    wireguard-tools
    # Dev
    devbox
    go
    python3
    nim
    bun
    pocketbase
    edgedb
    bruno
    ripgrep
    zip
    nodejs
    gcc
    python312Packages.pip
    android-studio
    android-tools
    jre17_minimal
    # Nvim-Lsps
    lua-language-server
    tailwindcss-language-server
    glow
    # Hacks
    responder-patched


    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = { };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/m3tam3re/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
    TERMINAL = "kitty";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    ELECTRON_EXTRA_FLAGS = "--force-device-scale-factor=1.5";
    #_JAVA_AWT_WM_NONREPARENTING = "1";
    #MOZ_DRM_DEVICE = "/dev/dri/card0:/dev/dri/card1";
    #WLR_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1";
    #WLR_NO_HARDWARE_CURSORS = "1"; # if no cursor,uncomment this line
    #GBM_BACKEND = "nvidia-drm";
    #CLUTTER_BACKEND = "wayland";
    LIBVA_DRIVER_NAME = "iHD";
    #WLR_RENDERER = "vulkan";
    #VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
    #__GLX_VENDOR_LIBRARY_NAME = "nvidia";
    #__NV_PRIME_RENDER_OFFLOAD = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GTK_USE_PORTAL = "1";
    GTK_THEME = "Nightfox-dark";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_BIN_HOME = "${config.home.homeDirectory}/.nix-profile/bin";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

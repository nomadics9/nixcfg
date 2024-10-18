{ config, lib, pkgs, user, ... }:

{
  home.username = lib.mkDefault user;
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    tailscale
    htop
    bun
    lua-language-server
    kitty
  ];

  home.file = { };

  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_BIN_HOME = "${config.home.homeDirectory}/.nix-profile/bin";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

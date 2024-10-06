{ pkgs, ... }: {
  imports = [
    ./fonts.nix
    ./hyprland.nix
    ./wayland.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [
  ];
}

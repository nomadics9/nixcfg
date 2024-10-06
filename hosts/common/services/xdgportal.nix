{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.common.services.xdgportal;
in
{
  options.common.services.xdgportal.enable = mkEnableOption "XDG Extra portal";

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = false;
      # gtkUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        # xdg-desktop-portal-hyprland
        # xdg-desktop-portal-wlr
      ];
      # wlr.enable = true;
    };
  };
}

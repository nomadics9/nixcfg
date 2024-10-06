{ config
, lib
, ...
}:
with lib; let
  cfg = config.common.services.nautilus;
in
{
  options.common.services.nautilus.enable = mkEnableOption "Gnome Filemanager";

  config = mkIf cfg.enable {

    services.gnome.gnome-keyring.enable = true;
    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
    services.gvfs.enable = true;
    services.tumbler.enable = true;
  };
}

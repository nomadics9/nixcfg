{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.features.themes.qt;
in
{
  options.features.themes.qt.enable = mkEnableOption "qt theme";

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style = {
        name = "adwaita-dark";
      };
    };

    home.packages = with pkgs;
      [
        adwaita-qt6
      ];
  };
}

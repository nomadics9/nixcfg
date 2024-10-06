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

    qt.enable = true;
    qt.platformTheme.name = "adwaita";
    qt.style = {
      name = "adwaita-dark";
    };

    home.packages = with pkgs; [
      adwaita-qt6
    ];
  };
}

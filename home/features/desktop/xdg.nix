{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.features.desktop.xdg;
in
{
  options.features.desktop.xdg.enable = mkEnableOption "XDG Dirs";

  config = mkIf cfg.enable {

    home.file.".config/user-dirs.dirs".text = /*bash*/ ''
      XDG_DESKTOP_DIR="$HOME/Desktop"
      XDG_DOWNLOAD_DIR="$HOME/Downloads"
      XDG_PUBLICSHARE_DIR="$HOME/Public"
      XDG_DOCUMENTS_DIR="$HOME/Documents"
      XDG_MUSIC_DIR="$HOME/Music"
      XDG_PICTURES_DIR="$HOME/Photos"
      XDG_VIDEOS_DIR="$HOME/Video"
    '';
  };
}

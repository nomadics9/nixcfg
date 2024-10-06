{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.features.desktop.fonts;
in
{
  options.features.desktop.fonts.enable =
    mkEnableOption "install additional fonts for desktop apps";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fira-code
      fira-code-symbols
      fira-code-nerdfont
      font-manager
      font-awesome_5
      font-awesome
      noto-fonts-emoji
      noto-fonts
      jetbrains-mono
    ];
  };
}

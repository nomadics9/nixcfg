{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.features.themes.gtk;
in
{
  options.features.themes.gtk.enable = mkEnableOption "gtk theme";

  config = mkIf cfg.enable {

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };


    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          theme = "Nightfox-Dark";
        };
        "org/gnome/shell/extensions/user-theme" = {
          theme = "Nightfox-Dark";
        };
      };
    };

    gtk = {
      enable = true;
      font.name = "JetBrainsMono Nerd Font";
      font.size = 10;
      theme = {
        name = "Nightfox-Dark";
        package = pkgs.nightfox-gtk-theme;
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };



      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = ''1'';
      };
      gtk4.extraConfig = {
        gtk-theme-name = ''Nightfox:Dark'';
      };

    };
  };
}




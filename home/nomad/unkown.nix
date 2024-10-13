{
  imports = [
    ../common
    ./dotfiles
    ../features/cli
    ../features/desktop
    ../features/themes
    ./home.nix
  ];

  features = {
    cli = {
      zsh.enable = true;
      fzf.enable = true;
      neofetch.enable = true;
    };
    desktop = {
      fonts.enable = true;
      hyprland.enable = true;
      wayland.enable = true;
      xdg.enable = true;
    };
    themes = {
      gtk.enable = true;
      qt.enable = true;
    };
  };



  wayland.windowManager.hyprland = {
    settings = {
      device = [
        {
          name = "keyboard";
          kb_layout = "us,ara";
        }
        {
          name = "mouse";
          sensitivity = -0.5;
        }
      ];
      monitor = [
        "eDP-1,1920x1080@60,0x0,1"
        "DP-2,1920x1080@60,auto,1"

      ];
      workspace = [
        "1, monitor:eDP-1, default:true"
        "2, monitor:eDP-1"
        "3, monitor:eDP-1"
        "4, monitor:eDP-1"
        "5, monitor:eDP-1"
        "6, monitor:eDP-1"
        "7, monitor:eDP-1"
      ];
    };
  };
}


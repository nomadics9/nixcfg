{
  imports = [
    ../common
    ./dotfiles
    ../features/cli
    ../features/desktop
    ../features/themes
    ./unkown/home.nix
  ];

  features = {
    cli = {
      zsh.enable = false;
      nushell.enable = false;
      fish.enable = true;
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
      monitor = [
        "DP-1,highres,auto,1"
        "eDP-1,2560x1600@60,0x0,1.25,mirror,DP-1"

      ];
      workspace = [
        # "1, monitor:DP-1, default:true"
        # "2, monitor:DP-1"
        # "3, monitor:DP-1"
        # "4, monitor:DP-1"
        # "5, monitor:DP-1"
        # "6, monitor:DP-1"
        # "7, monitor:DP-1"
      ];
    };
  };
}


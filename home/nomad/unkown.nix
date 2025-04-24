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
      nushell.enable = true;
      fish.enable = true;
      fzf.enable = true;
      neofetch.enable = true;
    };
    desktop = {
      fonts.enable = true;
      hyprland.enable = false;
      wayland.enable = false;
      xdg.enable = false;
    };
    themes = {
      gtk.enable = true;
      qt.enable = true;
    };
  };

}


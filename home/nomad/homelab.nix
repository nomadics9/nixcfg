{
  imports = [
    ../common
    ./dotfiles/nvim.nix
    ../features/cli
    ../features/desktop
    ../features/themes
    ./home/home.nix
  ];

  features = {
    cli = {
      zsh.enable = true;
      fzf.enable = true;
      neofetch.enable = true;
    };
    desktop = {
      fonts.enable = true;
    };
  };
}


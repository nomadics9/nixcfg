{
  imports = [
    ../common
    ./dotfiles/nvim.nix
    ../features/cli
    ./vps/home.nix
  ];

  features = {
    cli = {
      fish.enable = true;
      fzf.enable = true;
      neofetch.enable = true;
    };
  };
}


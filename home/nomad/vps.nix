{
  imports = [
    ../common
    ./dotfiles/nvim.nix
    ../features/cli
    ./vps/home.nix
  ];

  features = {
    cli = {
      zsh.enable = true;
      fzf.enable = true;
      neofetch.enable = true;
    };
  };
}


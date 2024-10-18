{ pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./fzf.nix
    ./neofetch.nix
  ];

  # Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = { enable = true; };

  home.packages = with pkgs; [
    coreutils
    fd
    htop
    ripgrep
    tldr
    zip
    exiftool
    nvtopPackages.full
  ];
}

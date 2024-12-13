{ pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./fzf.nix
    ./neofetch.nix
    ./nushell.nix
    ./fish.nix
  ];

  # Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
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
    chafa
    nvtopPackages.full
  ];
}

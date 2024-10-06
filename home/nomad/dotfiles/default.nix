{ inputs, ... }: {
  imports = [
    ./bat.nix
    ./dunst.nix
  ];

  home.file.".config/nvim" = {
    source = "${inputs.dotfiles}/nvim";
    recursive = true;
  };

  home.file.".config/hypr/scripts" = {
    source = "${inputs.dotfiles}/scripts";
    recursive = true;
  };
}

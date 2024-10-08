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

  home.file.".config/hypr/" = {
    source = "${inputs.dotfiles}/hypr/hyprlock/Style-2";
    recursive = true;
  };

  home.file.".config/hypr/" = {
    source = "${inputs.dotfiles}/hypr/hyprpaper.conf";
    recursive = true;
  };

  home.file.".config/wlogout/" = {
    source = "${inputs.dotfiles}/wlogout";
    recursive = true;
  };

}

{ inputs, pkgs, ... }: {
  imports = [
    ./bat.nix
    ./kitty.nix
    ./rofi.nix
    ./nvim.nix
  ];

  home.file.".config/mako" = {
    source = "${inputs.dotfiles}/mako";
    recursive = true;
  };

  home.file.".config/hypr/scripts" = {
    source = "${inputs.dotfiles}/scripts";
    recursive = true;
  };

  home.file.".config/hypr" = {
    source = pkgs.symlinkJoin {
      name = "hypr-config";
      paths = [
        "${inputs.dotfiles}/hypr/hyprlock/Style-2"
        "${inputs.dotfiles}/hypr/hyprpaper"
        "${inputs.dotfiles}/hypr/hypridle"
      ];
    };
    recursive = true;
  };

  home.file.".config/wlogout/" = {
    source = "${inputs.dotfiles}/wlogout";
    recursive = true;
  };

}

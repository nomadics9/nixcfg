{ config
, lib
, ...
}:
with lib; let
  cfg = config.features.cli.zsh;
in
{
  options.features.cli.zsh.enable = mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      # loginExtra = ''
      #   set -x NIX_PATH nixpkgs=channel:nixos-unstable
      #   set -x NIX_LOG info
      #   set -x TERMINAL kitty
      #
      #   if test (tty) = "/dev/tty1"
      #     exec Hyprland &> /dev/null
      #   end
      # '';

      shellAliases = {
        switchhypr = "sudo nixos-rebuild switch --flake .#hyprland";
        switchuhypr = "sudo nixos-rebuild switch --upgrade --flake .#hyprland";
        switchgnome = "sudo nixos-rebuild switch --flake .#gnome";
        switchugnome = "sudo nixos-rebuild switch --upgrade --flake .#gnome";
        clean = "sudo nix-collect-garbage -d";
        cleanold = "sudo nix-collect-garbage --delete-old";
        cleanboot = "sudo /run/current-system/bin/switch-to-configuration boot";
        nvim = "kitty @ set-spacing padding=0 && /run/current-system/sw/bin/nvim";
        zed = "steam-run zed";
      };
      initExtraFirst = "
    unsetopt beep
    ";
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      #  zplug = {
      #  enable = true;
      #  plugins = [
      #    { name = "zsh-users/zsh-autosuggestions"; }
      #    { name = "zsh-users/zsh-syntax-highlighting"; }
      #    { name = "romkatv/zsh-defer"; }
      #    ];
      # };
    };
  };
}

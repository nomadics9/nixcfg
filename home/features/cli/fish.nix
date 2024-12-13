{ config
, lib
, ...
}:
with lib; let
  cfg = config.features.cli.fish;
in
{
  options.features.cli.fish.enable = mkEnableOption "enable extended fish configuration";

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;

      shellAliases = {
        rebuild = "sudo nixos-rebuild switch";
        dotfilesu = "nix flake lock --update-input dotfiles";
        cleanold = "sudo nix-collect-garbage --delete-old";
        cleanboot = "sudo /run/current-system/bin/switch-to-configuration boot";
      };
      functions = {
        fish_greeting = ''
          chafa --align=Center ~/sync/0nmd/logo.webp --scale=0.8 -f symbols --symbols w
        '';
      };
    };
  };
}

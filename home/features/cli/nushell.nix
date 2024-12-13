{ config
, lib
, ...
}:
with lib; let
  cfg = config.features.cli.nushell;
in
{
  options.features.cli.nushell.enable = mkEnableOption "enable extended nushell configuration";

  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;

      shellAliases = {
        rebuild = "sudo nixos-rebuild switch";
        dotfilesu = "nix flake lock --update-input dotfiles";
        cleanold = "sudo nix-collect-garbage --delete-old";
        cleanboot = "sudo /run/current-system/bin/switch-to-configuration boot";

      };
    };
  };
}

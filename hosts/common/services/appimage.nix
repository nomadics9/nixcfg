{ config
, lib
, ...
}:
with lib; let
  cfg = config.common.services.appimage;
in
{
  options.common.services.appimage.enable = mkEnableOption "enable appimage";

  config = mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}

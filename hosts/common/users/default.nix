{ user, ... }:
{
  imports = [ ./${user}.nix ];
}

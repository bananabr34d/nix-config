{ lib, ... }:
with lib.hm.gvariant;
{
  imports = [
    ../../../services/keybase.nix
    ../../../services/maestral.nix
    ../../../services/mpris-proxy.nix
    ../../../services/syncthing.nix
    ../../../desktop/sakura.nix
  ];
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri = "file:///home/joe/Pictures/wallpaper/background.png";
    };
  };
}

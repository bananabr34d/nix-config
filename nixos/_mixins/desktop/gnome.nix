# NOTE: This is the minimum Pantheon, included in the live .iso image
# For actuall installs pantheon-apps.nix is also included
{ pkgs, ... }: {
  imports = [
    # ./qt-style.nix
    ../services/networkmanager.nix
  ];

  # Exclude the elementary apps I don't use
  environment = {
    gnome.excludePackages = with pkgs; [
      gnome.gnome-weather
      gnome.gnome-calendar
      gnome.gnome-maps
      gnome.gnome-contacts
      gnome.gnome-software
      gnome.totem
      gnome.epiphany
      gnome.evince
      gnome-tour      
    ];

  };

  services = {
    xserver = {
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
      desktopManager = {
        gnome = {
          enable = true;
          extraGSettingsOverrides = ''
            [org.gnome.settings-daemon.plugins.color]
            night-light-enabled=true
            night-light-last-coordinates=(30.495, -91.423)
            night-light-temperature=uint32 3700
            '';
        };
      };
    };
  };
  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs;
    with gnomeExtensions; [
      gnome.dconf-editor
      gnome.gnome-tweaks
      native-window-placement
      appindicator
      (pop-shell.overrideAttrs (old: rec {
        version = "unstable-2023-04-27";
        src = fetchFromGitHub {
          owner = "pop-os";
          repo = "shell";
          rev = "b5acccefcaa653791d25f70a22c0e04f1858d96e";
          sha256 = "w6EBHKWJ4L3ZRVmFqZhCqHGumbElQXk9udYSnwjIl6c=";
        };
        patches = [ ];
        postPatch = ''
          for file in */main.js; do
            substituteInPlace $file --replace "gjs" "${pkgs.gjs}/bin/gjs"
          done
        '';
      }))
      gnome-bedtime
    ];
  programs.geary.enable = false;  
}

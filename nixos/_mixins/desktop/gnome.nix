# NOTE: This is the minimum Pantheon, included in the live .iso image
# For actuall installs pantheon-apps.nix is also included
{ pkgs, ... }: {
  imports = [
    ./qt-style.nix
    ../services/networkmanager.nix
  ];

  # Exclude the elementary apps I don't use
  environment = {
    gnome.excludePackages = with pkgs.gnome; [
      gnome-weather
      gnome-calendar
      gnome-maps
      gnome-contacts
      gnome-software
      totem
      epiphany
      evince
      tour      
    ];

    # App indicator
    # - https://discourse.nixos.org/t/anyone-with-pantheon-de/28422
    # - https://github.com/NixOS/nixpkgs/issues/144045#issuecomment-992487775
    pathsToLink = [ "/libexec" ];
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

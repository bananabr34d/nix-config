{ config, lib, pkgs, ... }:
with lib.hm.gvariant;
{

    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "grp:alt_shift_toggle" "caps:none" ];
    };

    "org/gnome/desktop/interface" = {
      clock-format = "24h";
      color-scheme = "prefer-dark";
      cursor-size = 32;
      cursor-theme = "elementary";
      document-font-name = "Work Sans 12";
      font-name = "Work Sans 12";
      gtk-theme = "io.elementary.stylesheet.bubblegum";
      gtk-enable-primary-paste = true;
      icon-theme = "elementary";
      monospace-font-name = "FiraCode Nerd Font Medium 13";
      text-scaling-factor = 1.0;
    };

    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 7200;
    };

    "org/gnome/desktop/sound" = {
      theme-name = "elementary";
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-left = [ "<Primary><Alt>Left" ];
      switch-to-workspace-right = [ "<Primary><Alt>Right" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      audible-bell = false;
      button-layout = ":minimize,maximize,close";
      num-workspaces = 8;
      titlebar-font = "Work Sans Semi-Bold 12";
      workspace-names = [ "Web" "Work" "Chat" "Code" "Virt" "Cast" "Fun" "Stuff" ];
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
      dynamic-workspaces = false;
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Super>Left" ];
      toggle-tiled-right = [ "<Super>Right" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>e";
      command = "io.elementary.files -n ~/";
      name = "io.elementary.files -n ~/";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-timeout = 0;
      sleep-inactive-ac-type = "nothing";
    };

    #"org/gnome/settings-daemon/plugins/xsettings" = {
    #  overrides = "{\'Gtk/DialogsUseHeader\': <0>, \'Gtk/ShellShowsAppMenu\': <0>, \'Gtk/EnablePrimaryPaste\': <1>, \'Gtk/DecorationLayout\': <\':minimize,maximize,close,menu\'>, \'Gtk/ShowUnicodeMenu\': <0>}";
    #};

    "org/gtk/gtk4/Settings/FileChooser" = {
      clock-format = "24h";
    };

    "org/gtk/Settings/FileChooser" = {
      clock-format = "24h";
    };

  };

  gtk = {

    font = {
      name = "Work Sans 12";
      package = pkgs.work-sans;
    };

    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      extraConfig = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

  };

}

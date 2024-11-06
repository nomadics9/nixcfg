{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.features.desktop.hyprland;
in
{
  options.features.desktop.hyprland.enable = mkEnableOption "hyprland config";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        xwayland = {
          force_zero_scaling = true;
        };

        exec-once = [
          "waybar"
          "hyprpaper"
          "hypridle"
          "wl-clipboard-history -t"
          "wl-paste -p -t text --watch clipman store -P --histpath=\"~/.local/share/clipman-primary.json\""
          "poweralertd"
          "syncthing"
          "sleep 3; qsyncthingtray"
          "kdeconnect-indicator"
          #"kdeconnectd"
          "dbus-update-actvation-environment --systemd --all WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DBUS_SESSION_BUS_ADDRESS"
        ];

        env = [
          "XCURSOR_SIZE,24"
          "NIXOS_OZONE_WL,1"
          "GTK_THEME,Nightfox-Dark"
        ];

        input = {
          kb_layout = "us,ara";
          kb_options = "grp:alt_shift_toggle";
          kb_variant = "qwerty_digits";
          #kb_model = "pc105";
          #kb_rules = "evdev";
          follow_mouse = 1;

          touchpad = {
            natural_scroll = true;
            disable_while_typing = 1;
            tap-to-click = 1;
          };

          sensitivity = 0.1;
        };

        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;
          "col.active_border" = "rgba(5faaffee) rgba(5faaffee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
        };

        decoration = {
          "col.shadow" = "rgba(1E202966)";
          drop_shadow = true;
          shadow_range = 60;
          shadow_offset = "1 2";
          shadow_render_power = 3;
          shadow_scale = 0.97;
          rounding = 8;
          blur = {
            enabled = true;
            size = 3;
            passes = 3;
          };
          active_opacity = 1;
          inactive_opacity = 0.95;
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = { };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_min_speed_to_force = 5;
        };

        misc = {
          vfr = true;
        };

        windowrule = [
          "float, file_progress"
          "float, confirm"
          "float, dialog"
          "float, download"
          "float, notification"
          "float, error"
          "float, splash"
          "float, confirmreset"
          "float, title:Open File" # decrease screen brightness
          "float, title:branchdialog"
          "float, Rofi"
          "float, Calculator"
          "float, mako"
          "float,viewnior"
          "float,feh"
          "float, pavucontrol-qt"
          "float, pavucontrol"
          "float, file-roller"
          "fullscreen, wlogout"
          "float, title:wlogout"
          "fullscreen, title:wlogout"
          "idleinhibit focus, vlc"
          "idleinhibit fullscreen, firefox"
          "float, title:^(Media viewer)$"
          "float, title:^(Volume Control)$"
          "float, title:^(Picture-in-Picture)$"
          "size 1160 960, title:^(Volume Control)$"
          "move 5 315, title:^(Volume Control)$"
          "float, title:^(fly_is_kitty)"
        ];

        "$mainMod" = "SUPER";



        bind = [
          "$mainMod, Escape, exec, wlogout -p layer-shell"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"


          "$mainMod, F1, exec, $HOME/.config/hypr/scripts/keybind.sh"
          "$mainMod, Q, killactive"
          "$mainMod, B, exec, firefox"
          "$mainMod, F, fullscreen, 1"
          "$mainModSHIFT, F, fullscreen, 0"
          "$mainMod, V, togglesplit" # dwindle

          "$mainMod, j, movefocus, d"
          "$mainMod, k, movefocus, u"

          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"

          "$mainMod SHIFT, h, movewindow, l"
          "$mainMod SHIFT, l, movewindow, r"
          "$mainMod SHIFT, k, movewindow, u"
          "$mainMod SHIFT, j, movewindow, d"

          "$mainMod SHIFT, t, exec, kitty --start-as=fullscreen -o 'font_size=18' --title all_is_kitty"
          "ALT, RETURN, exec, kitty --title fly_is_kitty"
          "$mainMod, RETURN, exec, kitty --title kitty_term"

          "$mainMod, C, killactive"
          "$mainMod SHIFT, Q, exit"
          "$mainMod, E, exec, nautilus"
          "$mainMod, R, exec, ~/.config/rofi/launchers/type-6/launcher.sh"
          #"$mainMod, P, pseudo"


          "ALTCTRL, DELETE, exec, htop"
          "$mainMod, T, togglefloating"

          # Screen shot
          "$mainMod, S, exec, hyprctl keyword animation 'fadeOut,0,0,default'; grimshot --notify copy active; hyprctl keyword animation 'fadeOut,1,4,default'"
          "$mainMod SHIFT, S, exec, grimshot savecopy area - | swappy -f - -o ~/Photos/screenshot-$(date +'%d-%m-%Y_%H:%M').png"

          # Screen recorder
          "$mainMod SHIFT, R, exec, wf-recorder -a -f ~/Video/recording.mkv & notify-send 'Recordering Started' -i -u -A '^C ,stop' -t 0 -i ~/icons/rec-button.png"

          # Emoji selector
          "$mainMod SHIFT, E, exec, rofimoji"


          # Change HZ
          "$mainMod, A, exec, ~/.config/hypr/scripts/screenHz.sh"

          "$mainMod SHIFT, RETURN, layoutmsg, swapwithmaster"

          # Workspace bindings
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          "$mainModSHIFT, 1, movetoworkspacesilent, 1"
          "$mainModSHIFT, 2, movetoworkspacesilent, 2"
          "$mainModSHIFT, 3, movetoworkspacesilent, 3"
          "$mainModSHIFT, 4, movetoworkspacesilent, 4"
          "$mainModSHIFT, 5, movetoworkspacesilent, 5"
          "$mainModSHIFT, 6, movetoworkspacesilent, 6"
          "$mainModSHIFT, 7, movetoworkspacesilent, 7"
          "$mainModSHIFT, 8, movetoworkspacesilent, 8"
          "$mainModSHIFT, 9, movetoworkspacesilent, 9"
          "$mainModSHIFT, 0, movetoworkspacesilent, 10"

          "ALT, Tab, cyclenext"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        binde = [
          "$mainMod, left, resizeactive, -40 0"
          "$mainMod, right, resizeactive, 40 0"
          "$mainMod, up, resizeactive, 0 -40"
          "$mainMod, down, resizeactive, 0 40"
          ", XF86AudioMute, exec, $HOME/.config/hypr/scripts/volume mute"
          ", XF86AudioLowerVolume, exec, $HOME/.config/hypr/scripts/volume down"
          ", XF86AudioRaiseVolume, exec, $HOME/.config/hypr/scripts/volume up"
          ", XF86MonBrightnessUp, exec, $HOME/.config/hypr/scripts/brightness up"
          ", XF86MonBrightnessDown, exec, $HOME/.config/hypr/scripts/brightness down"
        ];


        windowrulev2 = [
          # "workspace 1,class:(Emacs)"
          # "workspace 3,opacity 1.0, class:(brave-browser)"
          # "workspace 4,class:(com.obsproject.Studio)"
        ];
      };
    };
  };

}


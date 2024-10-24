{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.features.desktop.wayland;
in
{
  options.features.desktop.wayland.enable = mkEnableOption "wayland extra tools and config";

  config = mkIf cfg.enable {

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          height = 20;
          layer = "top";
          modules-left = [ "custom/launcher" "custom/wg" "cpu" "memory" "custom/weather" "hyprland/workspaces" ];
          modules-center = [ "mpris" ];
          modules-right = [ "network" "pulseaudio" "backlight" "battery" "clock" "tray" "hyprland/language" "custom/wallpaper" "idle_inhibitor" "custom/refresh-rate" ];

          "hyprland/workspaces" = {
            format = "{name}";
            all-outputs = true;
            on-click = "activate";
            format-icons = {
              active = " 󱎴";
              default = "󰍹";
            };
            persistent-workspaces = {
              "1" = [ ];
              "2" = [ ];
              "3" = [ ];
              "4" = [ ];
              "5" = [ ];
              "6" = [ ];
              "7" = [ ];
              "8" = [ ];
              "9" = [ ];
            };
          };
          "hyprland/language" = {
            format = "{short}";
          };

          "hyprland/window" = {
            max-length = 200;
            separate-outputs = true;
          };
          "tray" = {
            spacing = 10;
          };
          "clock" = {
            format = "{:%H:%M}";
            format-alt = "{:%b %d %Y}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          "cpu" = {
            interval = 10;
            format = "  {}%";
            max-length = 10;
            on-click = "";
          };
          "memory" = {
            interval = 30;
            format = "🧠 {}%";
            format-alt = "🧠 {used:0.1f}GB";
            max-length = 10;
          };
          "temperature" = {
            interval = 10;
            format = " {temperatureC}°C";
            max-length = 10;
          };
          "backlight" = {
            device = "intel_backlight";
            format = "{icon}";
            tooltip = true;
            format-alt = "<small>{percent}%</small>";
            format-icons = [ "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨" ];
            on-scroll-up = "brightnessctl set 1%+";
            on-scroll-down = "brightnessctl set 1%-";
            smooth-scrolling-threshold = "2400";
            tooltip-format = "Brightness {percent}%";
          };
          "network" = {
            format-wifi = "<small>{bandwidthDownBytes}</small> {icon}";
            min-length = 10;
            fixed-width = 10;
            format-ethernet = "󰈀";
            format-disconnected = "󰤭";
            tooltip-format = "{essid}";
            interval = 1;
            on-click = "~/.config/hypr/scripts/wofi-wifi.sh";
            format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          };

          "custom/wg" = {
            exec = "~/.config/hypr/scripts/wg-status.sh";
            interval = 5;
            format = "{}";
            on-click = "~/.config/hypr/scripts/wg-toggle.sh";
          };

          "bluetooth" = {
            format = "{icon}";
            format-alt = "bluetooth: {status}";
            interval = 30;
            format-icons = {
              enabled = "";
              disabled = "󰂲";
            };
            tooltip-format = "{status}";
          };

          "pulseaudio" = {
            format = "{icon}";
            format-muted = "󰖁";
            format-icons = {
              default = [ "" "" "󰕾" ];
            };
            on-click = "pamixer -t";
            on-scroll-up = "pamixer -i 1";
            on-scroll-down = "pamixer -d 1";
            on-click-right = "exec pavucontrol";
            tooltip-format = "Volume {volume}%";
          };

          "battery" = {
            bat = "BAT0";
            adapter = "ADP0";
            interval = 60;
            states = {
              warning = 20;
              critical = 15;
            };
            max-length = 20;
            format = "{icon}";
            format-warning = "{icon}";
            format-critical = "{icon}";
            format-charging = "<span font-family='Font Awesome 6 Free'></span>";
            format-plugged = "󰚥";
            format-notcharging = "󰚥";
            format-full = "󰂄";

            format-alt = "<small>{capacity}%</small> ";
            format-icons = [ "󱊡" "󱊢" "󱊣" ];
          };

          "custom/weather" = {
            format = "{}°C";
            tooltip = true;
            interval = 3600;
            exec = "wttrbar --location Kuwait";
            return-type = "json";
          };

          "mpris" = {
            format = "{player_icon} {title}";
            format-paused = " {status_icon} <i>{title}</i>";
            max-length = 80;
            player-icons = {
              default = "▶";
              mpv = "🎵";
            };
            status-icons = {
              paused = "⏸";
            };
          };

          "custom/refresh-rate" = {
            format = "{percentage}Hz";
            on-click = "~/.config/hypr/scripts/screenHz.sh";
            return-type = "json";
            exec = "cat ~/.config/hypr/scripts/hz.json";
            interval = 1;
            tooltip = false;
          };

          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = " ";
              deactivated = " ";
            };
          };

          "custom/launcher" = {
            format = "󱄅";
            on-click = "wofi --show drun --allow-images";
          };

          "custom/wallpaper" = {
            format = "󰸉 ";
            on-click = "bash ~/.config/hypr/scripts/changewallpaper.sh";
          };
        };
      };
      style = '' 
                  * {
            /* `otf-font-awesome` is required to be installed for icons */
            font-family: Material Design Icons, JetBrainsMono Nerd Font, Iosevka Nerd Font ;
            font-size: 14px;
            border: none;
            border-radius: 0;
            min-height: 0;
          }

          window#waybar {
            background-color: rgba(26, 27, 38, 0.5);
            color: #ffffff;
            transition-property: background-color;
            transition-duration: 0.5s;
          }

          window#waybar.hidden {
            opacity: 0.1;
          }

          #window {
            color: #64727d;
          }

          #clock,
          #temperature,
          #mpris, 
          #cpu,
          #memory,
          #custom-media,
          #tray,
          #mode,
          #custom-lock,
          #workspaces,
          #custom-launcher,
          #custom-spotify,
          #custom-weather,
          #custom-wg,
          #custom-weather.severe,
          #custom-weather.sunnyDay,
          #custom-weather.clearNight,
          #custom-weather.cloudyFoggyDay,
          #custom-weather.cloudyFoggyNight,
          #custom-weather.rainyDay,
          #custom-weather.rainyNight,
          #custom-weather.showyIcyDay,
          #custom-weather.snowyIcyNight,
          #custom-weather.default {
            color: #e5e5e5;
            border-radius: 6px;
            padding: 2px 10px;
            background-color: #252733;
            border-radius: 8px;
            font-size: 14px;

            margin-left: 4px;
            margin-right: 4px;

            margin-top: 8.5px;
            margin-bottom: 8.5px;
          }
          #temperature{
            color: #7a95c9;
          }
          #cpu {
            color: #fb958b;
          }

          #memory {
            color: #a1c999;
          }

          #workspaces button {
            color: #7a95c9;
            box-shadow: inset 0 -3px transparent;

            padding-right: 3px;
            padding-left: 4px;

            margin-left: 0.1em;
            margin-right: 0em;
            transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
          }

          #workspaces button.active {
            color: #ecd3a0;
            padding-left: 1px;
            padding-right: 5px;
            font-family: Iosevka Nerd Font;
            font-weight: bold;
            font-size: 12px;
            margin-left: 0em;
            margin-right: 0em;
            transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
          }

          /* If workspaces is the leftmost module, omit left margin */
          .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
          }

          /* If workspaces is the rightmost module, omit right margin */
          .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
          }

          #custom-launcher {
            margin-left: 12px;

            padding-right: 18px;
            padding-left: 14px;

            font-size: 22px;

            color: #7a95c9;

            margin-top: 8.5px;
            margin-bottom: 8.5px;
          }
          #bluetooth,
          #backlight,
          #battery,
          #pulseaudio,
          #network {
            background-color: #252733;
            padding: 0em 2em;

            font-size: 14px;

            padding-left: 7.5px;
            padding-right: 7.5px;

            padding-top: 3px;
            padding-bottom: 3px;

            margin-top: 7px;
            margin-bottom: 7px;
            
            font-size: 20px;
          }

          #pulseaudio {
            color: #81A1C1;
            padding-left: 9px;
            font-size: 22px;
          }

          #pulseaudio.muted {
            color: #fb958b;
            padding-left: 9px;
            font-size: 22px;
          }

          #backlight {
            color: #ecd3a0;
            padding-right: 5px;
            padding-left: 8px;
            font-size: 21.2px;
          }

          #network {
            padding-left: 0.2em;
            color: #5E81AC;
            border-radius: 8px 0px 0px 8px;
            padding-left: 14px;
            padding-right: 14px;
            font-size: 20px;
          }

          #network.disconnected {
            color: #fb958b;
          }

          #bluetooth {
            padding-left: 0.2em;
            color: #5E81AC;
            border-radius: 8px 0px 0px 8px;
            padding-left: 14px;
            padding-right: 14px;
            font-size: 20px;
          }

          #bluetooth.disconnected {
            color: #fb958b;
          }


          #battery {
            color: #8fbcbb;
            border-radius: 0px 8px 8px 0px;
            padding-right: 12px;
            padding-left: 12px;
            font-size: 22px;
          }

          #battery.critical,
          #battery.warning,
          #battery.full,
          #battery.plugged {
            color: #8fbcbb;
            padding-left: 12px;
            padding-right: 12px;
            font-size: 22px;
          }

          #battery.charging { 
            font-size: 18px;
            padding-right: 12px;
            padding-left: 12px;
          }

          #battery.full,
          #battery.plugged {
            font-size: 22.5px;
            padding-right: 12px;
          }

          @keyframes blink {
            to {
              background-color: rgba(30, 34, 42, 0.5);
              color: #abb2bf;
            }
          }

          #battery.warning {
            color: #ecd3a0;
          }

          #battery.critical:not(.charging) {
            color: #fb958b;
          }

          #custom-lock {
            color: #ecd3a0;
            padding: 0 15px 0 15px;
            margin-left: 7px;
            margin-top: 7px;
            margin-bottom: 7px;
          }
          #clock {
            color: #8a909e;
            font-family: Iosevka Nerd Font;
            font-weight: bold;
            margin-top: 7px;
            margin-bottom: 7px;
          }
        
          #language,
          #custom-refresh-rate,
          #custom-wallpaper,
          #idle_inhibitor {
            background-color: #252733;
    color: #8a909e;
    font-family: JetBrains Mono Nerd Font;
    font-weight: bold;
    font-size: 17px;
    padding: 0 7px; /* Adjust padding here */
    margin-top: 7px;
    margin-bottom: 7px;
    padding-top: 3px;
    padding-bottom: 3px;
}

#language {
    border-radius: 8px 0 0 8px; /* Rounded on the left */
}

#custom-refresh-rate {
    border-radius: 0 8px 8px 0; /* Rounded on the right */
    margin-right: 12px;
}

#custom-wallpaper,
#idle_inhibitor {
    /* No border-radius here to avoid separation */
    padding-left: 7px;
    padding-right: 7px;
}

/* Remove additional borders/margins that might cause separation */
#idle_inhibitor,
#custom-wallpaper {
    margin-left: 0; /* Reset margin */
    margin-right: 0; /* Reset margin */
    margin-top: 7px; /* Reset margin */
    margin-bottom: 7px; /* Reset margin */
}

          tooltip {
            font-family: Iosevka Nerd Font;
            border-radius: 15px;
            padding: 15px;
            background-color: #1f232b;
          }

          tooltip label {
            font-family: Iosevka Nerd Font;
            padding: 5px;
          }

          label:focus {
            background-color: #1f232b;
          }

          #tray {
            margin-right: 8px;
            margin-top: 7px;
            margin-bottom: 7px;
            font-size: 30px;

          }

          #tray > .passive {
            -gtk-icon-effect: dim;
          }

          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background-color: #eb4d4b;
          }

          #idle_inhibitor.activated {
            background-color: #ecf0f1;
            color: #2d3436;
            border-radius: 8px
          }
          #mpris,
          #custom-spotify {
            color: #abb2bf;
          }

          #custom-weather {
            font-family: Iosevka Nerd Font;
            font-size: 14px;
            color: #8a909e;
          }

          #custom-weather.severe {
            color: #eb937d;
          }

          #custom-weather.sunnyDay {
            color: #c2ca76;
          }

          #custom-weather.clearNight {
            color: #cad3f5;
          }

          #custom-weather.cloudyFoggyDay,
          #custom-weather.cloudyFoggyNight {
            color: #c2ddda;
          }

          #custom-weather.rainyDay,
          #custom-weather.rainyNight {
            color: #5aaca5;
          }

          #custom-weather.showyIcyDay,
          #custom-weather.snowyIcyNight {
            color: #d6e7e5;
          }

          #custom-weather.default {
            color: #dbd9d8;
          }
    '';
    };

    home.packages = with pkgs; [
      wofi
      wofi-emoji
      dbus
      sway-contrib.grimshot
      hyprlock
      hypridle
      hyprpaper
      hyprpicker
      qt6.qtwayland
      kdePackages.qt6ct
      slurp
      swappy
      waypipe
      wf-recorder
      wl-mirror
      wl-clipboard
      wlogout
      wtype
      wttrbar
      ydotool
      xdg-utils
      xwaylandvideobridge
      playerctl
      brightnessctl
      pamixer
      pavucontrol # Volume control
      dunst # Notifications
      jellyfin-ffmpeg # Multimedia libs
      viewnior # Image viewr
      libcanberra-gtk3 # Notification sound

      # Gnome Stuff
      gtk-engine-murrine
      gnome-software
      gnome-disk-utility
      gnome-text-editor
      file-roller
      gnome-calculator
      nautilus # Gnome file manager
      gnome-system-monitor

    ];
  };
}

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
          modules-right = [ "network" "pulseaudio" "backlight" "battery" "tray" "hyprland/language" "custom/wallpaper" "idle_inhibitor" "custom/refresh-rate" "clock" ];

          "hyprland/workspaces" = {
            format = "{name}";
            all-outputs = true;
            on-click = "activate";
            format-icons = {
              active = "󱎴";
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
            format = "🤖 {}%";
            max-length = 10;
          };

          "memory" = {
            interval = 30;
            format = "🧠 {}%";
            format-alt = "🧠 {used:0.1f}GB";
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
              warning = 15;
              critical = 7;
            };
            max-length = 20;
            format = "{icon}";
            format-warning = "{icon}";
            format-critical = "{icon}";
            format-charging = "<span font-family='Font Awesome 6 Free'></span>";
            format-plugged = "󰚥";
            format-notcharging = "󰚥";
            format-full = "󰂄";
            format-alt = "<small>{capacity}%</small>";
            format-alt-warning = "<small>{capacity}%</small>";
            format-critical-alt = "<small>{capacity}%</small>";
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


      style = /*css*/ '' 
  
        * {
          font-family: JetBrains Mono, JetBrainsMono Nerd Font, Material Design Icons;
          font-size: 17px; 
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

        /* General styling for individual modules */
        #clock,
        #temperature,
        #mpris,
        #cpu,
        #memory,
        #tray,
        #workspaces,
        #custom-launcher,
        #custom-weather,
        #custom-wg {
          background-color: #222034;
          font-size: 14px;
          color: #8a909e;
          padding: 3px 8px;
          border-radius: 8px;
          margin: 8px 2px;
        }

        /* Styling for Network, Pulseaudio, Backlight, and Battery group */
        #network,
        #pulseaudio,
        #backlight,
        #battery {
          background-color: #222034;
          font-size: 20px;
          padding: 3px 8px;
          margin: 8px 0px;
        }

        /* Module-specific colors for Network, Pulseaudio, Backlight, Battery */
        #network, #pulseaudio { color: #5796E0; }
        #backlight { color: #ecd3a0; }
        #battery { 
        color: #8fbcbb;
        padding-right: 14px
        }

        /* Battery state-specific colors */
        #battery.warning { color: #ecd3a0; }
        #battery.critical:not(.charging) { color: #fb958b; }

        /* Pulseaudio mute state */
        #pulseaudio.muted { color: #fb958b; }

        /* Styling for Language, Custom Wallpaper, Idle Inhibitor, Custom Refresh Rate group */
        #language,
        #custom-refresh-rate,
        #custom-wallpaper,
        #idle_inhibitor {
          background-color: #222034;
          color: #8a909e;
          padding: 3px 4px;
          margin: 8px 0px;
        }

        /* Rounded corners for specific group elements */
        #language { border-radius: 8px 0 0 8px; }
        #custom-refresh-rate { border-radius: 0 8px 8px 0; }
        #network { border-radius: 8px 0 0 8px; }
        #battery { border-radius: 0 8px 8px 0; }

        /* Temperature, CPU, and Memory colors */
        #temperature { color: #5796E0; }
        #cpu { color: #fb958b; }
        #memory { color: #a1c999; }

        /* Workspaces active button styling */
        #workspaces button {
          color: #5796E0;
          border-radius: 8px;
          box-shadow: inset 0 -3px transparent;
          padding: 3px 4px;
          transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
        }
        #workspaces button.active {
          color: #ecd3a0;
          font-weight: bold;
          border-radius: 8px;
          transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
        }

        #idle_inhibitor.activated {
          background-color: #ecf0f1;
          color: #2d3436;
          border-radius: 8px;
        }

        /* Custom launcher */
        #custom-launcher {
          color: #5796E0;
          font-size: 22px;
          padding-right: 14px;
        }

        /* Tooltip styling */
        tooltip {
          border-radius: 15px;
          padding: 15px;
          background-color: #222034;
        }
        tooltip label {
          padding: 5px;
          font-size: 14px;
          }

  '';
    };

    home.packages = with pkgs; [
      dbus
      sway-contrib.grimshot
      hyprlock
      hypridle
      hyprpaper
      hyprpicker
      rofi-wayland
      rofimoji
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
      jellyfin-ffmpeg # Multimedia libs
      viewnior # Image viewr
      mako # Notifications
      libcanberra-gtk3 # Notification sound
      libnotify # notify-send

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


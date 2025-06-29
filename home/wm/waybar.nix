{
  userOptions,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      bar = {
        layer = "top";
        position = "top";
        mod = "dock";
        gtk-layer-shell = true;
        exclusive = true;
        passthrough = false;
        height = 40;
        modules-left = ["custom/leftpad" "hyprland/workspaces" "custom/rightpad"];
        modules-center = ["custom/leftpad" "hyprland/window" "clock" "mpris" "custom/rightpad"];
        modules-right = ["custom/leftpad" "pulseaudio" "network" "temperature" "cpu"] ++ lib.optionals (userOptions.device == "laptop") ["custom/battery"] ++ lib.optionals (userOptions.nvidia) ["custom/nvidia-gpu"] ++ ["disk" "custom/rightpad"];

        # Audio visualiser

        "cava" = {
          framerate = 30;
          autosens = 1;
          bars = 14;
          lower_cutoff_freq = 50;
          higher_cutoff_freq = 10000;
          method = "pulse";
          source = "auto";
          stereo = true;
          reverse = false;
          monstercat = false;
          waves = false;
          noise_reduction = 0.8;
          bar_delimiter = 0;
          hide_on_silence = true;
          sleep_timer = 5;
          input_delay = 2;
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          actions = {
            on-right-click = "mode";
          };
        };

        "clock" = {
          interval = 1;
          # format = " {:L%H:%M}";
          format = " {:L%H:%M, %m月%e日(%a)}";
          # Time, Weekday, Month, Day, Year
          # format-alt = " {:%T, %A, %B %d, %Y }";
          locale = "ja_JP.UTF-8";
          format-alt = " {:L%T, %Y年%m月%e日(%a)}";
          tooltip-format = "<span size='9pt' font='Noto Sans CJK HK'>{calendar}</span>";
          calendar = {
            mode = "month";
            # Have to keep it at 2 for now: https://github.com/Alexays/Waybar/issues/2240
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#6272A4'><b>{}</b></span>";
              days = "<span color='#F8F8F2'><b>{}</b></span>";
              weeks = "<span color='#282A36'><b>W{}</b></span>";
              weekdays = "<span color='#50FA7B'><b>{}</b></span>";
              today = "<span color='#FF5555'><b>{}</b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
          };
        };

        "cpu" = {
          interval = 6;
          format = " {usage}%";
        };

        "disk" = {
          interval = 60;
          format = " {percentage_used}%";
        };

        "hyprland/workspaces" = {
          all-outputs = true;
          # show-special = true;
          format = "{id}: {windows}";
          # format = "{icon} {windows}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
          };
          window-rewrite-default = " ";
          window-rewrite = {
            "class<Alacritty>" = " ";
            "class<kitty>" = " ";
            "class<firefox>" = " ";
            "class<floorp>" = " ";
            "class<discord>" = " ";
            "class<com\\.obsproject\\.Studio>" = " ";
            "class<.*libre.*>" = " ";
          };
        };

        "hyprland/window" = {
          format = "{title}";
          rewrite = {
            # Both formats are used at this format
            "(.*) — Mozilla Firefox" = "  $1";
            "Mozilla Firefox" = " ";
            "(.*) — Ablaze Floorp" = "  $1";
            "Ablaze Floorp" = " ";
            " - Discord" = " "; # To prevent an extra space when no more text is to be displayed
            "(.*) - Discord" = "  $1"; # Discord always displays like this, even if `(.*)` is empty
            "cava" = " ";
          };
        };

        "memory" = {
          interval = 6;
          format = "{percentage}%";
        };

        # Firefox doesn't implement that much, is what it is :(
        # Maybe look to using a TUI?
        "mpris" = {
          # Delay feels really bad here
          interval = 0.5;
          format = "󰗃 {title}";
          format-paused = " {title}";
          # Defaults to:
          # left click = "play/pause";
          # middle click = "previous";
          # right click = "next";
        };

        "network" = {
          interval = 30;
          format = "{ifname}";
          format-ethernet = "";
          format-wifi = " {essid} ({signalStrength}%)";
          format-disconnected = "  Disconnected";
        };

        "pulseaudio" = {
          format-muted = " Muted";
          states = {
            danger = 100;
            high = 60;
            medium = 30;
            low = 15;
          };
          format-danger = " {volume}%";
          format-high = " {volume}%";
          format-medium = " {volume}%";
          format-low = " {volume}%";
          # Toggle pavucontrol
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = "pgrep pavucontrol | xargs kill || pavucontrol &> /dev/null";
          # Scrolling changes volume
          scroll-step = 1.0;
          ignored-sinks = ["Easy Effects Sink"];
        };

        "temperature" = {
          interval = 6;
          format = "{temperatureC}°C";
        };

        "custom/nvidia-gpu" = {
          interval = 6;
          exec = "echo  $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)%";
        };

        "custom/battery" = {
          interval = 10;
          exec = "echo \" $(cat /sys/class/power_supply/BAT0/capacity)% | $(cat /sys/class/power_supply/BAT0/status)\"";
        };

        "custom/leftpad" = {
          format = " ";
          interval = "once";
          tooltip = false;
        };

        "custom/rightpad" = {
          format = " ";
          interval = "once";
          tooltip = false;
        };
      };
    };
    style = ./waybar.css;
  };
}

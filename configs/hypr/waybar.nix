{userOptions, ...}:

{
  bar = {
    layer = "top";
    position = "top";
    height = 30;
    spacing = 8;
    modules-left = ["hyprland/workspaces"];
    modules-center = ["hyprland/window" "clock" "mpris"];
    modules-right = ["cava" "pulseaudio" "network" "temperature" "cpu" "custom/gpu" "disk"];

    # Audio visualiser
    "cava" = {
      # TODO: use ${builtins.getEnv "HOME"} or similar
      cava_config = "/home/jeremy/.config/cava/config";
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
      format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
      actions = {
        on-right-click = "mode";
      };
    };


    "clock" = {
      interval = 1;
      format = " {:%H:%M}";
      format-alt = " {:%T, %A, %B %d, %Y }";
      tooltip-format = "<tt><small>{calendar}</small></tt>";
      calendar = {
        mode = "month";
        # Have to keep it at 2 for now: https://github.com/Alexays/Waybar/issues/2240
        mode-mon-col = 2;
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
      window-rewrite-default = "";
      window-rewrite = {
        "class<Alacritty>" = "";
        "class<firefox>" = "";
        "class<discord>" = "";
        "class<com\\.obsproject\\.Studio>" = "";
        "class<.*libre.*>" = "";
      };
      # format = "{id}: {icon}";
      # format-icons = {
      #   "1" = "";
      #   "2" = "";
      #   "3" = "";
      #   "urgent" = "";
      #   "special" = "";
      #   "default" = "";
      # };
    };

    "hyprland/window" = {
      format = "{title}";
      rewrite = {
        "(.*) — Mozilla Firefox" = "  $1";
        "(.*) - Discord" = "  $1";
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
      # The delay feels horrible
      interval = 1;
      format = " {title}";
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
      scroll-step = 1.0;
    };

    "temperature" = {
      interval = 6;
      format = "{temperatureC}°C";
    };

    "custom/gpu" = {
      interval = 6;
      exec = "echo   $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)%";
    };

    # TODO: Add UPower settings - makes more sense to do it at a laptop

  };
}

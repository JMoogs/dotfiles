{
  lib,
  userOptions,
  ...
}: {
  # See https://wiki.hyprland.org/Configuring/Monitors/
  monitor =
    if userOptions.device == "pc"
    then [
      "DP-1, 2560x1440@143.91, 0x0, 1"
      "HDMI-A-1, 1920x1080@60, 2560x300, 1"
      "Unknown-1, disable"
    ]
    else [", preferred, auto, 1"];

  # Bind workspaces to correct monitors
  workspace =
    if userOptions.device == "pc"
    then [
      "1, monitor:DP-1, default=true"
      "2, monitor:HDMI-A-1, default = true"
      "3, monitor:HDMI-A-1"
    ]
    else null;

  # Execute your favorite apps at launch
  # exec-once = waybar & hyprpaper & firefox (floorp)
  exec-once =
    [
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "waypaper --restore --random"
      "waybar"
      "ags"
      "zen"
    ]
    ++ lib.optionals (userOptions.device == "pc") ["xrandr --output DP-1 --primary"];

  # Source a file (multi-file configs)
  # source = ~/.config/hypr/myColors.conf

  # Some default env vars
  # + Nvidia setup
  env = ["XCURSOR_SIZE, 24" "HYPRCURSOR_THEME, HyprBibataModernClassicSVG"] ++ lib.optionals (userOptions.nvidia) ["LIBVA_DRIVER_NAME, nvidia" "XDG_SESSION_TYPE, wayland" "GBM_BACKEND, nvidia-drm" "__GLX_VENDOR_LIBRARY_NAME, nvidia" "NIXOS_OZONE_WL, 1"];

  # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
  input = {
    kb_layout = "gb";
    kb_options = "compose:ralt";
    follow_mouse = 1;
    sensitivity = 0;
    touchpad.natural_scroll = true;
    tablet = {
      output = "DP-2";
      left_handed = true;
    };
  };

  general = {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    gaps_in = 5;
    gaps_out = 20;
    border_size = 2;
    "col.active_border" = "rgb(44475A) rgb(BD93F9) 90deg";
    "col.inactive_border" = "rgba(44475AAA)";
    "col.nogroup_border" = "rgba(282A36DD)";
    "col.nogroup_border_active" = "rgb(BD93F9) rgb(44475A) 90deg";

    layout = "dwindle";

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false;
  };

  # cursor = {
  #   no_hardware_cursors = true;
  #   enable_hyprcursor = false;
  # };

  decoration = {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    rounding = 10;

    blur = {
      enabled = true;
      size = 3;
      passes = 1;
    };

    shadow = {
      enabled = true;
      range = 60;
      render_power = 3;
      scale = 0.97;
      offset = "1 2";
    };
  };

  animations = {
    enabled = "yes";

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

    animation = ["windows, 1, 7, myBezier" "windowsOut, 1, 7, default, popin 80%" "border, 1, 10, default" "borderangle, 1, 8, default" "fade, 1, 7, default" "workspaces, 1, 6, default"];
  };

  dwindle = {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = "yes"; # you probably want this
  };

  master = {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_status = "master";
  };

  misc = {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
  };

  "$mainMod" = "SUPER";

  bind = [
    # Terminal
    "$mainMod, RETURN, exec, kitty"
    # Backup terminal
    "$mainMod SHIFT, RETURN, exec, alacritty"
    # The classic
    "ALT, F4, killactive, "
    # Quit Hyprland
    "$mainMod SHIFT, Escape, exit,"
    # Floating
    "$mainMod, V, togglefloating, "
    # Browser shortcut
    "$mainMod, F, exec, zen"
    # Anki shortcut
    "$mainMod, A, exec, anki"
    # App Launcher
    "$mainMod, D, exec, rofi -show drun"
    # Full screen
    "$mainMod SHIFT, F, fullscreen"
    # Lock screen
    "CONTROL ALT, L, exec, hyprlock"
    # No idea tbh
    "$mainMod, P, pseudo," # dwindle
    "$mainMod, W, togglesplit," # dwindle
    # Blue light filter
    "$mainMod, B, exec, hyprshade toggle blue-light-filter"
    # Screenshots
    ", Print, exec, grimblast --freeze copy area"
    "ALT, Print, exec, grimblast copy active"
    "SUPER, Print, exec, grimblast copy output"
    "CONTROL, Print, exec, grimblast copy screen"

    # Resize a window to 1500x1125 (for Touhou)
    "$mainMod, T, resizeactive, exact 1500 1125"

    # # Move focus with mainMod + arrow keys
    "$mainMod, left, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"
    # Same with vim bindings
    "$mainMod, H, movefocus, l"
    "$mainMod, L, movefocus, r"
    "$mainMod, K, movefocus, u"
    "$mainMod, J, movefocus, d"

    # Switch workspaces with mainMod + [0-9]
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

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    "$mainMod SHIFT, 1, movetoworkspace, 1"
    "$mainMod SHIFT, 2, movetoworkspace, 2"
    "$mainMod SHIFT, 3, movetoworkspace, 3"
    "$mainMod SHIFT, 4, movetoworkspace, 4"
    "$mainMod SHIFT, 5, movetoworkspace, 5"
    "$mainMod SHIFT, 6, movetoworkspace, 6"
    "$mainMod SHIFT, 7, movetoworkspace, 7"
    "$mainMod SHIFT, 8, movetoworkspace, 8"
    "$mainMod SHIFT, 9, movetoworkspace, 9"
    "$mainMod SHIFT, 0, movetoworkspace, 10"

    # Example special workspace (scratchpad)
    "$mainMod, S, togglespecialworkspace, magic"
    "$mainMod SHIFT, S, movetoworkspace, special:magic"

    # Scroll through existing workspaces with mainMod + scroll
    "$mainMod, mouse_down, workspace, e-1"
    "$mainMod, mouse_up, workspace, e+1"

    # Volume and Playback controls
    ",XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -3%"
    ",XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +3%"
    ",XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
    ",XF86AudioPlay, exec, playerctl play-pause"
    ",XF86AudioNext, exec, playerctl next"
    ",XF86AudioPrev, exec, playerctl previous"
    "CONTROL $mainMod, up, exec, playerctl volume 0.04+"
    "CONTROL $mainMod, down, exec, playerctl volume 0.04-"
    "CONTROL $mainMod, left, exec, playerctl position 5-"
    "CONTROL $mainMod, right, exec, playerctl position 5+"

    # Toggle opacity
    "$mainMod, Q, exec, hyprctl setprop active opaque toggle"

    # Discord PTT binding
    ", mouse:276, pass, class:^(discord)$"

    # OBS bindings
    "$mainMod, Insert, pass, class:^(com\.obsproject\.Studio)$"
    "$mainMod, Home, pass, class:^(com\.obsproject\.Studio)$"
    "$mainMod, Prior, pass, class:^(com\.obsproject\.Studio)$"
  ];

  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

  windowrule = [
    "opacity 0.88, class:^(Alacritty)$"
    "opacity 0.88, class:^(kitty)$"
    "opacity 0.90, class:^(discord)$"
    "opacity 0.90, class:^(steam)$"
    "opacity 0.88, class:^(code)$"
    "opacity 0.88, title:^(Mozilla Firefox)$, xwayland:0" # Make firefox transparent when on the homepage (only on Wayland as the title doesn't change through XWL)
    "opacity 0.88, title:^(New Tab)(.*)$, xwayland:0" # Sometimes it has the title new tab as well
    "opacity 0.88, title:^(.*)(at DuckDuckGo)(.*)$, xwayland:0" # Searches can also be transparent
  ];
}

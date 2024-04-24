{lib, userOptions, ...}:

{
  # See https://wiki.hyprland.org/Configuring/Monitors/
  monitor = if userOptions.device == "pc" then ["DP-2, 2560x1440@144, 0x0, 1"
   "HDMI-A-2, 1920x1080@60, 2560x300, 1"] else [", preferred, auto, 1"];

  # Bind workspaces to correct monitors
  workspace = if userOptions.device == "pc" then ["1, monitor:DP-2, default=true" 
  "2, monitor:HDMI-A-2, default = true" "3, monitor:HDMI-A-2"] else null;

  # Execute your favorite apps at launch
  # exec-once = waybar & hyprpaper & firefox (floorp)
  exec-once = ["dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP" 
  "waypaper --restore --random"
  "waybar"
  "floorp"
  ] ++ lib.optionals (userOptions.device == "pc") ["xrandr --output DP-2 --primary"];

  # Source a file (multi-file configs)
  # source = ~/.config/hypr/myColors.conf

  # Some default env vars
  # + Nvidia setup
  env = ["XCURSOR_SIZE, 24" ] ++ lib.optionals (userOptions.nvidia) ["LIBVA_DRIVER_NAME, nvidia" "XDG_SESSION_TYPE, wayland" "GBM_BACKEND, nvidia-drm" "__GLX_VENDOR_LIBRARY_NAME, nvidia" "WLR_NO_HARDWARE_CURSORS, 1" "NIXOS_OZONE_WL, 1"];

  # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
  input = {
    kb_layout = "gb";
    follow_mouse = 1;
    sensitivity = 0;
    touchpad.natural_scroll = true;
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

  
  decoration = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      rounding = 10;
    
      blur = {
          enabled = true;
          size = 3;
          passes = 1;
      };

      drop_shadow = "yes";
      # shadow_range = 4;
      shadow_render_power = 3;

      shadow_range = 60;
      shadow_scale = 0.97;
      shadow_offset = "1 2";
      "col.shadow" = "rgba(1E202966)";
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
      new_is_master = true;
  };

  misc = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      force_default_wallpaper = -1; # Set to 0 to disable the anime mascot wallpapers
  };


  
  "$mainMod" = "SUPER";
  

  bind = [
    # Terminal
    "$mainMod, RETURN, exec, alacritty"
    # The classic
    "ALT, F4, killactive, "
    # Quit Hyprland
    "$mainMod SHIFT, Escape, exit,"
    # Floating
    "$mainMod, V, togglefloating, "
    # Firefox (floorp) shortcut
    "$mainMod, F, exec, floorp"
    # App Launcher
    "$mainMod, D, exec, rofi -show drun"
    # Full screen
    "$mainMod SHIFT, F, fullscreen"
    # Lock screen
    "CONTROL ALT, L, exec, hyprlock"
    # No idea tbh
    "$mainMod, P, pseudo," # dwindle
    "$mainMod, W, togglesplit," # dwindle
    # Screenshots
    ", Print, exec, grimblast copy area"
    "ALT, Print, exec, grimblast copy active"
    "SUPER, Print, exec, grimblast copy output"
    "CONTROL, Print, exec, grimblast copy screen"

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
    "$mainMod, Q, toggleopaque"

    # Discord PTT binding
    ", mouse:276, pass, ^(discord)$"

    # OBS bindings
    "$mainMod, Insert, pass, ^(com\.obsproject\.Studio)$"
    "$mainMod, Home, pass, ^(com\.obsproject\.Studio)$"
    "$mainMod, Prior, pass, ^(com\.obsproject\.Studio)$"
  ];


  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

  windowrulev2 = [
    # Discord fix (?)
    "forceinput, class:^(discord)$, xwayland:0"
    "opacity 0.88, class:^(Alacritty)$"
    "opacity 0.90, class:^(discord)$"
  ];

  
}

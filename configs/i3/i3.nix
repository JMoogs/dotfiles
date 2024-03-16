let modifier = "Mod4"; in {
    terminal = "alacritty";
    startup = [
     {command = "/etc/nixos/configs/i3/layoutPC.sh"; always = true;}
     {command = "/etc/nixos/configs/i3/polybar/launch.sh"; always = true;}
     {command = "feh --bg-scale /etc/nixos/wallpaper.png"; always = true;}
     {command = "picom"; always = true;}
     {command = "i3-msg \"exec firefox; exec discord; workspace 1;\"";}
    ];
    # Removes i3bars
    bars = [];

    # Dracula theme
    colors = {
     background = "#282A36";
     focused = let c = "#44475A"; in { border = c; background = c; childBorder = c; text = c; indicator = c; };
     urgent = let c = "#FF5555 "; in { border = c; background = c; childBorder = c; text = c; indicator = c; };
     unfocused = let c = "#282A36"; in { border = c; background = c; childBorder = c; text = c; indicator = c; };
    };

    window.titlebar = false;


    gaps.inner = 9;

    assigns = {"1" = [{ class = "alacritty";} ]; "2" = [{ class = "firefox"; }]; "3" = [{ class = "discord"; }]; };

    modes = {
     "resize" = {
 
      # Go back to normal mode
      "${modifier}+r" = "mode \"default\"";
      "Escape" = "mode \"default\"";
      "Return" = "mode \"default\"";

      "w" = "resize grow height 1 px or 1 ppt";
      "a" = "resize shrink width 1 px or 1 ppt";
      "s" = "resize shrink height 1 px or 1 ppt";
      "d" = "resize grow width 1 px or 1 ppt";
      "Up" = "resize grow height 1 px or 1 ppt";
      "Left" = "resize shrink width 1 px or 1 ppt";
      "Down" = "resize shrink height 1 px or 1 ppt";
      "Right" = "resize grow width 1 px or 1 ppt";

      "${modifier} + w" = "resize grow height 5 px or 5 ppt";
      "${modifier} + a" = "resize shrink width 5 px or 5 ppt";
      "${modifier} + s" = "resize shrink height 5 px or 5 ppt";
      "${modifier} + d" = "resize grow width 5 px or 5 ppt";
      "${modifier} + Up" = "resize grow height 5 px or 5 ppt";
      "${modifier} + Left" = "resize shrink width 5 px or 5 ppt";
      "${modifier} + Down" = "resize shrink height 5 px or 5 ppt";
      "${modifier} + Right" = "resize grow width 5 px or 5 ppt";
     };
     
    };

    keybindings = {

     # Launch apps
     "${modifier}+d" = "exec \"rofi -modi drun,run -show drun\"";

     # Swap to resize mode
     "${modifier}+r" = "mode \"resize\"";

     # Change window, vim + arrows
     "${modifier}+j" = "focus down";
     "${modifier}+k" = "focus up";
     "${modifier}+h" = "focus left";
     "${modifier}+l" = "focus right";

     "${modifier}+Down" = "focus down";
     "${modifier}+Up" = "focus up";
     "${modifier}+Left" = "focus left";
     "${modifier}+Right" = "focus right";

     # Move focused
     "${modifier}+Shift+j" = "move down";
     "${modifier}+Shift+k" = "move up";
     "${modifier}+Shift+h" = "move left";
     "${modifier}+Shift+l" = "move right";

     "${modifier}+Shift+Down" = "move down";
     "${modifier}+Shift+Up" = "move up";
     "${modifier}+Shift+Left" = "move left";
     "${modifier}+Shift+Right" = "move right";

     # Horizontal / Vert split
     "${modifier}+v" = "split v";
     "${modifier}+b" = "split h";

     # Container layout
     "${modifier}+w" = "layout tabbed";
     "${modifier}+e" = "layout toggle split";

     # Fullscreen
     "${modifier}+Shift+f" = "fullscreen toggle";

     # Toggle floating
     "${modifier}+Shift+space" = "floating toggle";

     # Focus parent
     "${modifier}+a" = "focus parent";

     # Workspaces
     "${modifier}+1" = "workspace number 1";
     "${modifier}+2" = "workspace number 2";
     "${modifier}+3" = "workspace number 3";
     "${modifier}+4" = "workspace number 4";
     "${modifier}+5" = "workspace number 5";
     "${modifier}+6" = "workspace number 6";
     "${modifier}+7" = "workspace number 7";
     "${modifier}+8" = "workspace number 8";
     "${modifier}+9" = "workspace number 9";
     "${modifier}+0" = "workspace number 10";
     # Move containers
     "${modifier}+Shift+1" = "move container to workspace number 1";
     "${modifier}+Shift+2" = "move container to workspace number 2";
     "${modifier}+Shift+3" = "move container to workspace number 3";
     "${modifier}+Shift+4" = "move container to workspace number 4";
     "${modifier}+Shift+5" = "move container to workspace number 5";
     "${modifier}+Shift+6" = "move container to workspace number 6";
     "${modifier}+Shift+7" = "move container to workspace number 7";
     "${modifier}+Shift+8" = "move container to workspace number 8";
     "${modifier}+Shift+9" = "move container to workspace number 9";
     "${modifier}+Shift+0" = "move container to workspace number 10";


     # Volume
     "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +4%";
     "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -4%";
     "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
     "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
     "XF86AudioNext" = "exec --no-startup-id playerctl next";
     "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
     # Screenshots
     "${modifier}+Shift+s" = "exec flameshot gui";
     "Print" = "exec flameshot full -c";
    

     # Rebind the horizontal key
     # Bind alt + f4
     "Mod1+F4" = "kill";
     # Alt + L to lock (needs changing)
     "Mod1+l" = "exec i3lock -c 282a36";
     # Restart session
     "${modifier}+Shift+r" = "restart";
     # Alacritty
     "${modifier}+Return" = "exec alacritty";
     # Firefox
     "${modifier}+f" = "exec firefox";
     # Backup console
     "${modifier}+Shift+Return" = "exec i3-sensible-terminal";
    };
}

{ themes, ... }:

# Reference:
# https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/
# https://github.com/hyprwm/hyprlock/blob/main/nix/hm-module.nix
# Config stolen from catppuccin: https://github.com/catppuccin/hyprlock/blob/main/hyprlock.conf

let theme = themes.hyprTheme; in {
  enable = true;

  general = {
    disable_loading_bar = true;
    hide_cursor = true;
  };

  backgrounds = [
    {
      monitor = "";
      path = themes.hyprlockWallpaper;
      blur_passes = 0;
      color = theme.base;
    }
  ];

  labels = [
    # Time
    {
      monitor = "";
      text = "cmd[update:30000] echo \"$(date +\"%R\")\"";
      color = theme.text;
      font_size = 90;

      position.x = -30;
      position.y = 0;
      halign = "right";
      valign = "top";
    }

    {
      monitor = "";
      text = "cmd[update:43200000] echo \"$(date +\"%A, %d %B %Y\")\"";
      color = theme.text;
      font_size = 25;
      position.x = -30;
      position.y = -150;
      halign = "right";
      valign = "top";
    }

  ];

  input-fields = [
    {
      monitor = "";
      size.width = 300;
      size.height = 60;
      outline_thickness = 4;
      dots_size = 0.2;
      dots_spacing = 0.2;
      dots_center = true;
      outer_color = theme.accent;
      inner_color = theme.surface0;
      font_color = theme.text;
      fade_on_empty = false;
      placeholder_text = "<span foreground=\"##${theme.textAlpha}\"><i>󰌾 Logged in as </i><span foreground=\"##${theme.accentAlpha}\">$USER</span></span>";
      hide_input = false;
      check_color = theme.accent;
      fail_color = theme.red;
      fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
      capslock_color = theme.yellow;
      position.x = 0;
      position.y = -35;
      halign = "center";
      valign = "center";
    }
  ];

  
}

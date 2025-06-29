{themes, ...}:
# Reference:
# https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/
# https://github.com/hyprwm/hyprlock/blob/main/nix/hm-module.nix
# Stolen from: https://github.com/FireStreaker2/dotfiles/blob/main/hypr/hyprlock.conf
let
  theme = themes.hyprTheme;
in {
  enable = true;

  settings = {
    general = {
      disable_loading_bar = true;
      hide_cursor = true;
    };

    background = [
      {
        monitor = "";
        path = themes.hyprlockWallpaper;
        blur_size = 4;
        blur_passes = 3;
        noise = 0.0117;
        contrast = 1.3;
        brightness = 0.8;
        vibrancy = 0.21;
        vibrancy_darkness = 0.0;
        color = theme.base;
      }
    ];

    label = [
      # Time
      {
        monitor = "";
        text = "cmd[update:1000] echo \"<b><big> $(date +'%H:%M') </big></b>\"";
        color = theme.text;
        font_size = 64;
        font_family = "JetBrains Mono Nerd Font 10";
        shadow_passes = 3;
        shadow_size = 3;

        position = "0, 10";
        halign = "center";
        valign = "center";
      }

      # Date
      {
        monitor = "";
        text = "cmd[update:1800000] echo \"<b> $(date +'%A, %-d %B %Y') </b>\"";
        color = theme.text;

        font_size = 24;
        font_family = "JetBrains Mono Nerd Font 10";

        position = "0, -40";
        halign = "center";
        valign = "center";
      }
    ];

    input-field = [
      {
        monitor = "";
        size = "250, 50";
        outline_thickness = 3;
        dots_size = 0.26;
        dots_spacing = 0.64;
        dots_center = true;
        fade_on_empty = true;
        placeholder_text = "<i>Password...</i>";
        hide_input = false;
        check_color = theme.accent;
        fail_color = theme.red;
        capslock_color = theme.yellow;
        position = "0, 50";
        halign = "center";
        valign = "bottom";
      }
    ];
  };
}

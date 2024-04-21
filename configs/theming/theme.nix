{pkgs, userOptions, ...}:

let theme = userOptions.theme; in {

  name = theme;

  gtkTheme = if theme == "dracula" then {
    name = theme;
    package = pkgs.dracula-theme;
  } else if theme == "frappe" then {
    name = theme;
    package = pkgs.catppuccin-gtk.override {
      variant = "frappe";
    };
  } else if theme == "latte" then {
    name = theme;
    package = pkgs.catppuccin-gtk.override {
      variant = "latte";
    };
  } else null;

  rofiTheme = "/etc/nixos/configs/theming/rofi/${theme}.rasi";

  alacrittyTheme = "/etc/nixos/configs/theming/alacritty/${theme}.yml";

  helixTheme = if theme == "dracula" then "dracula"
    else if theme == "frappe" then "catppuccin_frappe"
    else if theme == "latte" then "catppuccin_latte"
    else null;

  zellijTheme = if theme == "dracula" then "dracula_modified" else theme;

  cavaTheme = if theme == "dracula" then { foreground = "'#F8F8F2'"; background = "'#282A36'"; }
  else if theme == "frappe" then { foreground = "'#C6D0F5'"; background = "'#303446'"; }
  else if theme == "latte" then { foreground = "'#4C4F69'"; background = "'#EFF1F5'"; }
  else null;

  dunstTheme = /etc/nixos/configs/theming/dunst/${theme};

  hyprTheme = if theme == "dracula" then {
    base = "rgb(282a36)";
    text = "rgb(f8f8f2)";
    textAlpha = "f8f8f2";
    accent = "rgb(ffb86c)"; # Using dracula orange
    accentAlpha = "ffb86c";
    surface0 = "rgb(44475a)";
    red = "rgb(ff5555)";
    yellow = "rgb(f1fa8c)";
  }
  else if theme == "frappe" then {
    base = "rgb(303446)";
    text = "rgb(c6d0f5)";
    textAlpha = "c6d0f5";
    accent = "rgb(ca9ee6)"; # Mauve in catppuccin
    accentAlpha = "ca9ee6";
    surface0 = "rgb(414559)";
    red = "rgb(e78284)";
    yellow = "rgb(e5c890)";
  }
  else if theme == "latte" then {
    base = "rgb(eff1f5)";
    text = "rgb(4c4f69)";
    textAlpha = "4c4f69";
    accent = "rgb(8839ef)"; # Mauve in catppuccin
    accentAlpha = "8839ef";
    surface0 = "rgb(ccd0da)";
    red = "rgb(d20f39)";
    yellow = "rgb(df8e1d)";
  }
  else null;

  hyprlockWallpaper = if theme == "dracula" then "/etc/nixos/wallpapers/dracula/lockscreen.png"
  else if theme == "frappe" then "/etc/nixos/wallpapers/frappe/lockscreen.png"
  else if theme == "latte" then "/etc/nixos/wallpapers/latte/lockscreen.png"
  else null;

   
  
}

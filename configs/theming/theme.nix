{pkgs, userOptions, ...}:

let theme = userOptions.theme; in {

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

  swaylockColour = if theme == "dracula" then "282a36"
    else if theme == "frappe" then "303446"
    else if theme == "latte" then "eff1f5"
    else null;

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

   
  
}

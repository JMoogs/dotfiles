{lib, ...}: {
  # Make a custom option that can be used to set the theme
  options = {
    themingModule = {
      theme = lib.mkOption {
        type = lib.types.enum ["frappe" "latte" "dracula"];
        default = "frappe";
        description = "The theme to use.";
      };

      # themeName = lib.mkOption {
      #   type = lib.types.str;
      #   default = null;
      #   description = "The name of the theme to use.";
      #   readOnly = true;
      # };
      #
      # gtkTheme = lib.mkOption {
      #   type = lib.types.package;
      #   default = null;
      #   description = "The GTK theme package to use.";
      #   readOnly = true;
      # };
      #
      # rofiTheme = lib.mkOption {
      #   type = lib.types.str;
      #   description = "The path to the Rofi theme RASI file.";
      #   default = null;
      #   readOnly = true;
      # };
      #
      # alacrittyTheme = lib.mkOption {
      #   type = lib.types.str;
      #   default = null;
      #   description = "The path to the Alacritty theme TOML file.";
      #   readOnly = true;
      # };
      #
      # kittyTheme = lib.mkOption {
      #   type = lib.types.str;
      #   default = null;
      #   description = "The Kitty theme name.";
      #   readOnly = true;
      # };
      #
      # zellijTheme = lib.mkOption {
      #   type = lib.types.str;
      #   default = null;
      #   description = "The Zellij theme name.";
      #   readOnly = true;
      # };
      #
      # cavaTheme = lib.mkOption {
      #   type = lib.types.attrsOf lib.types.str;
      #   default = null;
      #   description = "The Cava theme name.";
      #   readOnly = true;
      # };
      #
      # yaziTheme = lib.mkOption {
      #   type = lib.types.attrsOf lib.types.unspecified;
      #   default = null;
      #   description = "The Yazi theme";
      #   readOnly = true;
      # };
      #
      # dunstTheme = lib.mkOption {
      #   type = lib.types.path;
      #   default = null;
      #   description = "The Dunst theme file path";
      #   readOnly = true;
      # };
      #
      # hyprTheme = lib.mkOption {
      #   type = lib.types.attrsOf lib.types.unspecified;
      #   default = null;
      #   description = "The Hyprland theme file path";
      #   readOnly = true;
      # };
      #
      # hyprlockWallpaper = lib.mkOption {
      #   type = lib.types.str;
      #   default = null;
      #   description = "The Hyprlock wallpaper file path";
      #   readOnly = true;
      # };
    };
  };
}

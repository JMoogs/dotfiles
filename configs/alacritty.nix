{ userOptions, themes, ... }:


{
    import = [ themes.alacrittyTheme ];
    font = {
      size = 15.5;
    };
    window = {
      title = "Terminal";
      opacity = if (userOptions.wm == "hyprland") then 1 else 0.93;
    };
    keybord.bindings = [
      { key = "Return"; mods = "Control|Shift"; action = "CreateNewWindow"; }
    ];
}

{
  userOptions,
  themes,
  ...
}: {
  enable = true;
  font.name = "DejaVu Sans";
  font.size =
    if userOptions.device == "pc"
    then 15.5
    else if userOptions.device == "laptop"
    then 17
    else 16;

  shellIntegration.enableFishIntegration = true;

  theme = themes.kittyTheme;

  settings = {
    confirm_os_window_close = 0;
    adjust_column_width = "105%";
  };
}

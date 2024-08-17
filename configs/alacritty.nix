{
  userOptions,
  themes,
  ...
}: {
  import = [themes.alacrittyTheme];
  font = {
    size =
      if userOptions.device == "pc"
      then 15.5
      else if userOptions.device == "laptop"
      then 17
      else 16;
  };
  window = {
    title = "Terminal";
  };
  keyboard.bindings = [
    {
      key = "Return";
      mods = "Control|Shift";
      action = "CreateNewWindow";
    }
  ];
}

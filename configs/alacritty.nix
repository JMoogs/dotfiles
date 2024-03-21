{ userOptions, ... }:
{
  enable = true;
  settings = {
      import = [ "/etc/nixos/configs/alacritty_dracula.yml" ];
      font = {
        size = 15.5;
      };
      window = {
        title = "Terminal";
        opacity = if (userOptions.wm == "hyprland") then 1 else 0.93;
      };
      keybord.bindings = [ {key = "Return"; mods = "Shift"; action = "SpawnNewInstance";} ];
  };
}

{
  pkgs,
  config,
  ...
}: let
  themes = import ../theming/getTheme.nix {
    inherit config;
    inherit pkgs;
  };
in {
  programs.kitty = {
    enable = true;
    font.name = "DejaVu Sans";
    font.size = 15.5;
    shellIntegration.enableFishIntegration = true;

    themeFile = themes.kittyTheme;

    settings = {
      confirm_os_window_close = 0;
      adjust_column_width = "105%";
    };
  };
}

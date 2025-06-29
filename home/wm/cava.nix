{
  userOptions,
  pkgs,
  ...
}: let
  themes = import ../theming/theme.nix {
    inherit userOptions;
    inherit pkgs;
  };
in {
  programs.cava = {
    enable = true;
    settings = {
      color = themes.cavaTheme;
    };
  };
}

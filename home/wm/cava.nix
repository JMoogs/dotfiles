{
  config,
  pkgs,
  ...
}: let
  themes = import ../theming/getTheme.nix {
    inherit config;
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

{
  pkgs,
  config,
  ...
}: let
  themes = import ./theming/getTheme.nix {
    inherit config;
    inherit pkgs;
  };
in {
  home.packages = with pkgs; [
    zip
    unzip
    ripgrep # A `grep` alternative for searching
    tree # A way of listing subdirectories as an alternative to `ls` in certain scenarios
    pandoc
    bat # A `cat` alternative with syntax highlighting among other things
    wget # Get files from the web
    file # Check file types
    bottom # A TUI system monitor
    rsync
    rclone
    tealdeer # A `tldr` client
    wl-clipboard # Clipboard
    grimblast # Screenshot utility
    waypaper # Wallpaper utility
    lutgen # A tool to recolour images: https://github.com/ozwaldorf/lutgen-rs
  ];

  # File manager
  programs.yazi = {
    enable = true;
    theme = themes.yaziTheme;
    enableFishIntegration = true;
  };

  # App launcher
  programs.rofi = {
    enable = true;
    theme = themes.rofiTheme;
    package = pkgs.rofi-wayland;
  };

  # File syncing
  services.syncthing.enable = true;
}

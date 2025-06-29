{
  pkgs,
  lib,
  userOptions,
  inputs,
  ...
}: let
  themes = import ./home/theming/theme.nix {
    inherit userOptions;
    inherit pkgs;
  };
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    # Shell
    ./home/shell
    # Fastfetch
    ./home/fastfetch.nix
    # Git settings
    ./home/git.nix
  ];

  home.sessionVariables = {
    CONFIG_THEME = themes.name;
  };

  # Any extra programs I want in my path can be added to this folder:
  home.sessionPath = ["$HOME/Documents/Apps"];
  home.packages = with pkgs;
    [
      # -----------------------------
      # Browsers
      firefox # Browser
      # -----------------------------
      # Development
      distrobox # VMs
      # Alternative editor
      vscode
      # Git
      git
      # LSPs (the ones that I want to be globally accessible)
      nil # Nix - Used for my main config and other smaller scripts
      marksman # Markdown - Often used in place of txt files
      # Compilers (the ones I want globally)
      rustup # Rust - For convinience as it's my most used language and `cargo install`
      ghc # Haskell - I use `ghci` often as a calculator or for small tasks
      # -----------------------------
      # Media
      yt-dlp # Youtube downloader
      ffmpeg # Media processing
      pulseaudio # Required for waybar muting
      pavucontrol # Sound controls
      playerctl # Playing media controls
      # -----------------------------
      # Utilities
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
      # -----------------------------
      # Note taking
      anki # Flashcards
      typst # A program for writing and formatting scientific documents
      obsidian # Markdown notes
      gimp # Editing
      inkscape # Vector editing
      # -----------------------------
      # Discord
      (discord.override {
        # Currently disabled as it has a bug preventing Discord activities from working
        # withOpenASAR = true; # A mod that rewrites part of Discord's code, making it faster: https://openasar.dev/
        withVencord = true; # A mod that allows for extra features including themes and plugins: https://vencord.dev/
      })
      vesktop # An alternative electron wrapper for Discord with Vencord built in: it allows for screensharing on Wayland
      telegram-desktop
      # -----------------------------
      # Ricing
      cbonsai # Draws trees in terminal that look cool and do nothing else
      font-awesome # A font with some different symbols
      # -----------------------------
      # Work
      libreoffice-qt # Alternatives to Microsoft Office
      # -----------------------------
      # Entertainment
      wineWowPackages.waylandFull # A way to emulate windows
      # -----------------------------
      # Security
      bitwarden # Password manager
      # -----------------------------
      # Misc.
      wl-clipboard # Clipboard
      grimblast # Screenshot utility
      hyprpaper # Set wallpapers
      hyprshade # Blue light filter and other shaders
      # waypaper # wallpaper GUI + randomizer
      waypaper
      (pkgs.callPackage ./pkgs/wayland-push-to-talk-fix.nix {}) # A fix for PTT on Discord on Wayland
      wlr-randr # Set primary monitor for certain games (Elden Ring)
      # -----------------------------
      # Libraries and random dependencies
      qt6.qtwayland
      libsForQt5.qt5.qtwayland
      libva
      bun
      dart-sass
      fd
      brightnessctl # Screen brightness controls
    ]
    ++ lib.optionals (userOptions.device == "pc") [
      # For heavier things that I probably won't use on my laptop
      r2modman # A mod manager
      obs-studio # Recording
      prismlauncher # An alternative minecraft launcher with modded support
      heroic # An alternative launcher for GOG and Epic Games
      lutgen # A tool to recolour images: https://github.com/ozwaldorf/lutgen-rs
    ];

  # Direnv to automatically enter nix shells
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Text Editor
  programs.nixvim = import ./home/neovim {
    inherit themes;
    inherit pkgs;
  };

  # Terminal emulator
  # programs.kitty = import ./home/kitty.nix {
  #   inherit userOptions;
  #   inherit themes;
  # };

  # Terminal multiplexer
  # programs.zellij = {
  #   enable = true;
  #   enableFishIntegration = false;
  #   settings = (import ./home/zellij.nix) {inherit userOptions;};
  # };

  # Theme for GTK apps
  gtk = {
    enable = true;
    theme = themes.gtkTheme;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  # App launcher
  programs.rofi = {
    enable = true;
    theme = themes.rofiTheme;
    package = pkgs.rofi-wayland;
  };

  # Audio visualiser
  programs.cava = {
    enable = true;
    settings = (import ./home/hypr/cava.nix) {inherit themes;};
  };

  # Taskbar
  programs.waybar = {
    enable = true;
    settings = (import ./home/hypr/waybar.nix) {
      inherit userOptions;
      inherit lib;
    };
    style = ./home/hypr/waybar.css;
  };

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = (import ./home/hypr/hypr.nix) {
      inherit lib;
      inherit userOptions;
    };
    package = inputs.hyprland.packages.${pkgs.system}.hyprland; # Uses master
  };

  # Lock screen
  programs.hyprlock =
    import ./home/hypr/hyprlock.nix {inherit themes;};

  # File manager
  programs.yazi = {
    enable = true;
    theme = themes.yaziTheme;
    enableFishIntegration = true;
  };

  # Mpv (media player) with mpris support among other things
  programs.mpv = {
    enable = true;
    scripts = with pkgs; [
      mpvScripts.mpris # Mpris support to control media with playerctl and to display media in taskbar
      mpvScripts.sponsorblock # Sponsorblock
      mpvScripts.youtube-upnext # Shows youtube's recommended videos when playing a video through mpv
      mpvScripts.mpv-cheatsheet # Shows keybinds
      mpvScripts.uosc # Alternate UI
      (mpvScripts.quality-menu.override {oscSupport = true;}) # Adds a quality menu to MPV when playing youtube videos
    ];
    config = {osd-font-size = 10;};
    # Add bindings to change video and audio quality when playing from youtube
    extraInput = ''
      Alt+f script-binding quality_menu/video_formats_toggle #! Stream Quality > Video
      Alt+g script-binding quality_menu/audio_formats_toggle #! Stream Quality > Audio
    '';
  };

  # Idle manager
  services.hypridle = import ./home/hypr/hypridle.nix {
    inherit userOptions;
    inherit lib;
  };

  # Audio effects
  services.easyeffects.enable = true;

  # Gpg
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  # File syncing
  services.syncthing.enable = true;

  # DO NOT CHANGE - Supposed to stay at the original install version
  home.stateVersion = "23.05";
}

{
  pkgs,
  lib,
  userOptions,
  inputs,
  ...
}: let
  themes = (import ./configs/theming/theme.nix) {
    inherit pkgs;
    inherit userOptions;
  };
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.ags.homeManagerModules.default
  ];

  # Any extra programs I want in my path can be added to this folder:
  home.sessionVariables = {
    CONFIG_THEME = themes.name;
  };
  home.sessionPath = ["$HOME/Documents/Apps"];
  home.packages = with pkgs;
    [
      # -----------------------------
      # Browsers
      firefox # Main browser
      floorp # Backup (firefox fork)
      mullvad-browser # Private browser
      # -----------------------------
      # Development
      # Alternative editor
      vscode
      # Sqlite browser
      sqlitebrowser
      # Git
      git
      jujutsu
      # Git TUI
      lazygit
      # LSPs (the ones that I want to be globally accessible)
      nil # Nix - Used for my main config and other smaller scripts
      haskellPackages.haskell-language-server # Haskell - Used for some quick scripts
      marksman # Markdown - Often used in place of txt files
      # Compilers (the ones I want globally)
      rustup # Rust - For convinience as it's my most used language and `cargo install`
      ghc # Haskell - I use `ghci` often as a calculator or for small tasks
      scala # Scala
      sbt # Scala build tool
      # -----------------------------
      # Media
      yt-dlp # Youtube downloader
      ffmpeg # Media processing
      pulseaudio # Required for waybar muting
      pavucontrol # Sound controls
      playerctl # Playing media controls
      youtube-music
      # -----------------------------
      # Utilities
      ripgrep # A `grep` alternative for searching
      tree # A way of listing subdirectories as an alternative to `ls` in certain scenarios
      bat # A `cat` alternative with syntax highlighting among other things
      curl-impersonate # Curl that impersonates firefox/chrome, allowing it to bypass cloudflare among other things
      killall # Kill all processes matching criteria
      wget # Get files from the web
      file # Check file types
      bottom # A TUI system monitor
      # -----------------------------
      # Note taking
      anki # Flashcards
      typst # A program for writing and formatting scientific documents
      typst-lsp # LSP for typst
      zathura # Minimal PDF viewer
      obsidian # Markdown notes
      wiki-tui # A wikipedia TUI
      gimp # Editting
      rnote # A way of handwriting notes
      # -----------------------------
      # Discord
      (discord.override {
        # Currently disabled as it has a bug preventing Discord activities from working
        # withOpenASAR = true; # A mod that rewrites part of Discord's code, making it faster: https://openasar.dev/
        withVencord = true; # A mod that allows for extra features including themes and plugins: https://vencord.dev/
      })
      vesktop # An alternative electron wrapper for Discord with Vencord built in: it allows for screensharing on Wayland
      element-desktop # A matrix client
      thunderbird # An email client
      # -----------------------------
      # Ricing
      cbonsai # Draws trees in terminal that look cool and do nothing else
      font-awesome # A font with some different symbols
      # -----------------------------
      # Work
      teams-for-linux # Microsoft Teams
      p3x-onenote # Microsoft OneNote
      libreoffice-qt # Alternatives to Microsoft Office
      # -----------------------------
      # Entertainment
      wineWowPackages.waylandFull # A way to emulate windows
      ani-cli # A CLI program to play anime
      syncplay # Sync video progress to watch videos with friends
      # -----------------------------
      # Security
      mullvad-vpn # VPN
      bitwarden # Password manager
      # -----------------------------
      # Misc.
      loupe # Image viewer
      wl-clipboard # Clipboard
      grimblast # Screenshot utility
      hyprpaper # Set wallpapers
      hyprshade # Blue light filter and other shaders
      # waypaper # wallpaper GUI + randomizer
      (pkgs.callPackage ./pkgs/waypaper.nix {}) # Custom waypaper for now as unstable isn't updated to 2.2, which is required for the Hyprpaper backend
      (pkgs.callPackage ./pkgs/wayland-push-to-talk-fix.nix {}) # A fix for PTT on Discord on Wayland
      xwaylandvideobridge # A fix for Wayland screensharing
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
      # Maths programming language
      # (sage.override {
      #   requireSageTests = false;
      # })
      godot_4 # Game engine
      gdtoolkit_4 # Other tools for working with godot
      r2modman # A mod manager
      distrobox # Vms
      qemu # Virtual Machine
      quickemu # Quick VM setup
      factorio-headless # Factorio server
      obs-studio # Recording
      prismlauncher # An alternative minecraft launcher with modded support
      heroic # An alternative launcher for GOG and Epic Games
      numbat # A calculator with type + dimension checking
      lutgen # A tool to recolour images: https://github.com/ozwaldorf/lutgen-rs
      webcord # Another electron wrapper for Discord, but without mods: it also allows for screensharing on Wayland, though streams generally seem lower quality than vesktop
    ];

  # Direnv to automatically enter nix shells
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Nixvim (text editor)
  programs.nixvim = import ./configs/neovim {
    inherit themes;
    inherit pkgs;
  };

  # Terminal emulator
  programs.alacritty = {
    enable = true;
    settings = (import ./configs/alacritty.nix) {
      inherit userOptions;
      inherit themes;
    };
  };

  # New terminal emulator
  programs.kitty = import ./configs/kitty.nix {
    inherit userOptions;
    inherit themes;
  };

  # Helix (text editor 2)
  programs.helix = {
    # defaultEditor = true;
    enable = true;
    settings = import ./configs/editor.nix {inherit themes;};
  };

  # Terminal multiplexer
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
    settings = (import ./configs/zellij.nix) {inherit userOptions;};
  };

  # Backup multiplexer
  programs.tmux = (import ./configs/tmux.nix) {inherit pkgs;};
  # Git
  programs.git = import ./configs/git.nix;
  # My shell
  programs.fish = import ./configs/fish.nix;

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
    settings = (import ./configs/hypr/cava.nix) {inherit themes;};
  };

  # Taskbar
  programs.waybar = {
    enable = true;
    settings = (import ./configs/hypr/waybar.nix) {
      inherit userOptions;
      inherit lib;
    };
    style = ./configs/hypr/waybar.css;
  };

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = (import ./configs/hypr/hypr.nix) {
      inherit lib;
      inherit userOptions;
    };
    package = inputs.hyprland.packages.${pkgs.system}.hyprland; # Uses master
  };

  # Lock screen
  programs.hyprlock =
    import ./configs/hypr/hyprlock.nix {inherit themes;};

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
  services.hypridle = import ./configs/hypr/hypridle.nix {
    inherit userOptions;
    inherit lib;
  };

  # Widgets for hypr
  programs.ags = {
    enable = true;
    configDir = ./configs/hypr/ags;
  };

  programs.fastfetch = {
    enable = true;
    settings = import ./configs/fastfetch.nix {};
  };

  # Currently testing using ags as a replacement
  # Notification daemon for hypr
  # services.dunst = {
  #   enable = true;
  #   configFile = themes.dunstTheme;
  # };

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

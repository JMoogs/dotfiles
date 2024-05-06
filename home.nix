{pkgs, lib, userOptions, inputs, ...}:

let themes = (import ./configs/theming/theme.nix) { inherit pkgs; inherit userOptions; }; in {

  imports = lib.optionals (userOptions.wm == "hyprland") [
    inputs.ags.homeManagerModules.default
    inputs.hyprlock.homeManagerModules.default
    inputs.hypridle.homeManagerModules.default
  ];

  # For any extra programs I want to install
  home.sessionPath = [ "$HOME/Documents/Apps" ];
  home.packages = with pkgs; [
    # Browsers

    # Main browser
    floorp
    # Backup browser
    firefox
    # -----------------------------

    # Terminal Setup

    # Multiplexer
    tmux
    # -----------------------------

    # Development
    # Git
    git
    # Git TUI
    lazygit

    # LSPs
      # Nix
    nil
      # Haskell
    haskellPackages.haskell-language-server
      # Markdown
    marksman

    # Compilers
      # Rust
    rustup
      # Haskell
    ghc

    # -----------------------------

    # Media

    # Mpv (media player) with mpris support
    (mpv.override {scripts = [mpvScripts.mpris]; })
    # Youtube downloader
    yt-dlp
    # Other utilities
    ffmpeg

    # -----------------------------

    # Utilities 

    # Mouse config software
    piper
    # Search tool (grep alternative)
    ripgrep
    # List subdirectories (ls alternative)
    tree
    # Self explanatory
    killall
    # Get files from the web
    wget
    # Check file types
    file
    # System monitor (TUI)
    bottom
    # File sync
    syncthing

    # -----------------------------

    # Note taking

    # Obisdian for MD notes
    obsidian
    # Wikipedia tui
    wiki-tui
    # Handwriting software
    xournalpp

    # -----------------------------

    # Comms

    # Discord with vencord
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    webcord
    # Matrix
    element-desktop
    # Email
    thunderbird

    # -----------------------------

    # Ricing

    # System info display
    neofetch 
    # Draw trees in terminal
    cbonsai
    # Change image colours for wallpapers
    lutgen # This thing is awesome
    # Font containing different symbols
    font-awesome
    nerdfonts

    # -----------------------------

    # Work

    # MS Teams
    teams-for-linux
    # MS Onenote
    p3x-onenote
    # Word alternative
    libreoffice-qt
    # Calculator
    numbat

    # -----------------------------

    # Entertainment

    # Steam
    steam
    # Minecraft launchger
    prismlauncher
    # Alt. Launcher for GOG and Epic games
    heroic
    # Windows emulation
    wineWowPackages.waylandFull
    # Anime
    ani-cli
    

    # -----------------------------

    # Security

    # VPN
    mullvad-vpn
    # Password manager
    bitwarden

    # -----------------------------

    # Misc.

    # Recording
    obs-studio
    # Image viewing and x11 wallpapers
    feh

    # Sound/music controls
    pavucontrol
    pulseaudio
    playerctl

  ] ++ lib.optionals (userOptions.wm == "hyprland") [

    grimblast

    # Clipboard for wayland
    wl-clipboard

    # Wallpapers
    swww
    waypaper
    
    # Wayland PTT fix for discord
    (pkgs.callPackage ./pkgs/wayland-push-to-talk-fix.nix {})
    # Wayland screenshare fix
    xwaylandvideobridge
    # Primary monitor fix
    wlr-randr

    # Libraries for wayland
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    libva

    # Dependencies for ags
    bun
    dart-sass
    fd
    brightnessctl
    

  ] ++ lib.optionals (userOptions.wm == "i3") [
    # Screenshot tool
    flameshot
    # Clipboard for x11
    xclip

  ] ++ lib.optionals (userOptions.device == "pc") [
     # For heavier things that I probably won't use on my laptop
     
    # Other maths
    (sage.override {
     requireSageTests = false; 
    })

    # Game engine
    godot_4
    gdtoolkit

    # Mod manager
    r2modman
  ];

  # Terminal emulator
  programs.alacritty = {
    enable = true;
    settings = (import ./configs/alacritty.nix) {inherit userOptions; inherit themes; };
  };

  # Editor
  programs.helix = {
    defaultEditor = true;
    enable = true;
    settings = import ./configs/editor.nix { inherit themes; };
    languages = {
      language-server.godot = {
        command = "nc";
        args = [ "127.0.0.1" "6005"];
      };
      
      language = [
        {
          name = "gdscript";
          language-servers = ["godot"];
        }
      ];
    };
  };

  # New multiplexer?
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = (import ./configs/zellij.nix) {inherit userOptions; };
  };

  programs.tmux = (import ./configs/tmux.nix) { inherit pkgs; };
  programs.git = import ./configs/git.nix;
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
    # theme = ./configs/rofiTheme.rasi;
    theme = themes.rofiTheme;
    package = if userOptions.wm == "hyprland" then pkgs.rofi-wayland else pkgs.rofi;
  };
  # Audio visualiser
  programs.cava = {
    enable = true;
    settings = (import ./configs/hypr/cava.nix) { inherit themes; };
  };

  # Taskbar for hypr
  programs.waybar = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    settings = (import ./configs/hypr/waybar.nix) { inherit userOptions; inherit lib; };
    style = ./configs/hypr/waybar.css;
  };

  # Hyprland
  wayland.windowManager.hyprland = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    settings = (import ./configs/hypr/hypr.nix) { inherit lib; inherit userOptions; };
  };

  # Lock screen for hypr
  programs.hyprlock = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland")
    (import ./configs/hypr/hyprlock.nix {inherit themes;});

  # Idle manager
  services.hypridle = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland")
    (import ./configs/hypr/hypridle.nix {inherit userOptions; inherit lib;});

  # Widgets for hypr
  # programs.ags = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
  #   enable = true;
  #   configDir = ./configs/hypr/ags;
  # };

  # Notification daemon for hypr
  services.dunst = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    configFile = themes.dunstTheme;
  };

  # i3wm
  xsession = lib.attrsets.optionalAttrs (userOptions.wm == "i3") {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = import ./configs/i3/i3.nix;
      extraConfig = if userOptions.device == "pc" then "workspace 1 output DP-2\nworkspace 2 output HDMI-1\nworkspace 3 output HDMI-1" else "";
    };
  };

  # Taskbar for i3
  services.polybar = lib.attrsets.optionalAttrs (userOptions.wm == "i3") {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      pulseSupport = true;
    };
    settings = (import ./configs/i3/polybar/polybar.nix) { inherit userOptions; };
    script = ":";
  };

  # Compositor for i3
  services.picom = lib.attrsets.optionalAttrs (userOptions.wm == "i3") {
    enable = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.92;
    opacityRules = [
      "100:class_g = 'i3lock'"
      "100:class_g = 'firefox'"
    ];
    settings = { corner-radius = 4; };
  };

  services.easyeffects.enable = true;

  # Gpg
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  # DO NOT CHANGE - Supposed to stay at the original install version 
  home.stateVersion = "23.05";
}

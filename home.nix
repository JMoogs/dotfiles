{pkgs, lib, userOptions, unstable, inputs, ...}:

let themes = (import ./configs/theming/theme.nix) { inherit pkgs; inherit userOptions; }; in{

  imports = lib.optionals (userOptions.wm == "hyprland") [
    inputs.ags.homeManagerModules.default
    inputs.hyprlock.homeManagerModules.default
  
  ];

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
    (mpv.override {scripts = [unstable.mpvScripts.mpris]; })
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

    # -----------------------------

    # Note taking

    # Obisdian for MD notes
    # Use unstable: https://github.com/NixOS/nixpkgs/issues/276988
    unstable.obsidian
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
    unstable.numbat

    # -----------------------------

    # Entertainment

    # Steam
    steam
    # Minecraft launchger
    prismlauncher
    # Alt. Launcher for GOG and Epic games
    heroic
    # Windows emulation
    unstable.wineWowPackages.waylandFull
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
    unstable.xwaylandvideobridge
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

    flameshot
    
    # Clipboard for x11
    xclip

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
    package = unstable.helix;
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
    settings = (import ./configs/hypr/waybar.nix) { inherit userOptions; };
    style = ./configs/hypr/waybar.css;
  };

  # Hyprland
  wayland.windowManager.hyprland = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    settings = (import ./configs/hypr/hypr.nix) { inherit lib; inherit userOptions; };
    package = unstable.hyprland;
  };

  # Lock screen for hypr
  programs.swaylock = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    settings = {
      # color = "282a36";
      color = themes.swaylockColour;
      font-size = 24;
      line-color = "44475a";
    };
  };

  programs.hyprlock = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland")
    (import ./configs/hypr/hyprlock.nix {inherit themes;});

  # Widgets for hypr
  programs.ags = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    configDir = ./configs/hypr/ags;
  };

  # Notification daemon for hyprl
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

  # Gpg
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  # DO NOT CHANGE - Supposed to stay at the original install version 
  home.stateVersion = "23.05";
}

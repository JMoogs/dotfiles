{pkgs, lib, userOptions, unstable, inputs, ...}:

{

  imports = lib.optionals (userOptions.wm == "hyprland") [ inputs.ags.homeManagerModules.default];

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

    # Utilities 

    # Search tool (grep alternative)
    ripgrep
    # List subdirectories (ls alternative)
    tree
    # Self explanatory
    killall
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

    # -----------------------------

    # Work

    # MS Teams
    teams-for-linux
    # MS Onenote
    p3x-onenote
    # Word alternative
    libreoffice-qt

    # -----------------------------

    # Games

    # Steam
    steam
    # Minecraft launchger
    prismlauncher
    # Alt. Launcher for GOG and Epic games
    heroic
    # Windows emulation
    wineWowPackages.stable

    # -----------------------------

    # VPN 

    mullvad-vpn

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

    # Clipboard for wayland
    wl-clipboard

    # Wallpapers
    swww
    waypaper
    
    # Wayland PTT fix for discord
    (pkgs.callPackage ./pkgs/wayland-push-to-talk-fix.nix {})
    # Wayland screenshare fix
    unstable.xwaylandvideobridge

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

    # Clipboard for x11
    xclip

  ];

  # Terminal emulator
  programs.alacritty = {
    enable = true;
    settings = (import ./configs/alacritty.nix) {inherit userOptions; };
  };

  # Editor
  programs.helix = {
    defaultEditor = true;
    enable = true;
    settings = import ./configs/editor.nix;
  };

  programs.tmux = (import ./configs/tmux.nix) { inherit pkgs; };
  programs.git = import ./configs/git.nix;
  programs.fish = import ./configs/fish.nix;

  # Theme for GTK apps
  gtk = {
    enable = true;
    theme = {
      name = "dracula";
      package = pkgs.dracula-theme;
    };
  };
  # App launcher
  programs.rofi = {
    enable = true;
    theme = ./configs/rofiTheme.rasi;
    package = if userOptions.wm == "hyprland" then pkgs.rofi-wayland else pkgs.rofi;
  };
  # Audio visualiser
  programs.cava = {
    enable = true;
    settings = import ./configs/hypr/cava.nix;
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
      color = "282a36";
      font-size = 24;
      line-color = "44475a";
    };
  };

  # Widgets for hypr
  programs.ags = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    configDir = ./configs/hypr/ags;
  };

  # Notification daemon for hyprl
  services.dunst = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    configFile = ./configs/hypr/dunst;
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

  # DO NOT CHANGE - Supposed to stay at the original install version 
  home.stateVersion = "23.05";
}

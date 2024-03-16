{pkgs, lib, userOptions, unstable, ...}:

{

  home.sessionPath = [ "$HOME/Documents/Apps" ];
  home.packages = with pkgs; [
    # Browser
    firefox

    # Terminal Setup
    tmux
    alacritty
    (lib.mkIf (userOptions.wm == "plasma") libsForQt5.yakuake)


    # Wayland setup (WIP)
    # Other
    (lib.mkIf (userOptions.wm == "hyprland") qt6.qtwayland)
    (lib.mkIf (userOptions.wm == "hyprland") libsForQt5.qt5.qtwayland)
    (lib.mkIf (userOptions.wm == "hyprland") libva)
    # Cool stuff
    cava 
    neofetch 
    cbonsai

    # Dev
    # Editor
    helix
    git
    # Git TUI
    lazygit
    # LSPs
    nil
    haskellPackages.haskell-language-server
    marksman
    # Rust
    rustup
    # Haskell
    ghc
    # Other utilities
    ripgrep
    tree
    killall
    (if userOptions.wm == "hyprland" then wl-clipboard else xclip)
    # System monitor
    bottom

    # Note taking
    # Use unstable: https://github.com/NixOS/nixpkgs/issues/276988
    unstable.obsidian
    wiki-tui
    xf86_input_wacom
    wacomtablet
    xournalpp

    # Teams + Onenote + libreoffice
    teams-for-linux
    p3x-onenote
    libreoffice-qt

    # Discord with vencord
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    # Wayland PTT fix
    (lib.mkIf (userOptions.wm == "hyprland") (pkgs.callPackage ./pkgs/wayland-push-to-talk-fix.nix {}))
    # Screenshare fix
    (lib.mkIf (userOptions.wm == "hyprland") unstable.xwaylandvideobridge)

    # Recording
    obs-studio

    # Games
    steam
    prismlauncher
    heroic
    wineWowPackages.stable

    # VPN 
    mullvad-vpn

    # Screenshots
    (if userOptions.wm == "hyprland" then grimblast else flameshot)

    # Wallpaper
    feh # General image viewing as well
    lutgen # This thing is awesome
    font-awesome
    (lib.mkIf (userOptions.wm == "hyprland") swww)
    (lib.mkIf (userOptions.wm == "hyprland") waypaper)

    # Sound controls
    pavucontrol
    pulseaudio
    playerctl
    


  ];

  programs.alacritty = import ./configs/alacritty.nix;
  programs.helix = import ./configs/editor.nix;
  programs.tmux = (import ./configs/tmux.nix) { inherit pkgs; };
  programs.git = import ./configs/git.nix;
  programs.fish = import ./configs/fish.nix;

  programs.rofi = lib.attrsets.optionalAttrs (userOptions.wm == "i3" || userOptions.wm == "hyprland") {
    enable = true;
    theme = ./configs/rofiTheme.rasi;
    package = if userOptions.wm == "hyprland" then pkgs.rofi-wayland else pkgs.rofi;
  };
  programs.waybar = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    settings = (import ./configs/hypr/waybar.nix) { inherit userOptions; };
    # style = import ./configs/hypr/waybar.css;
    style = ./configs/hypr/waybar.css;
  };
  programs.cava = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    settings = import ./configs/hypr/cava.nix;
  };

  wayland.windowManager.hyprland = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    settings = (import ./configs/hypr/hypr.nix) { inherit lib; inherit userOptions; };
    package = unstable.hyprland;
  };

  programs.swaylock = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    settings = {
      color = "282a36";
      font-size = 24;
      line-color = "44475a";
    };
    
  };

  xsession = lib.attrsets.optionalAttrs (userOptions.wm == "i3") {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = import ./configs/i3/i3.nix;
      extraConfig = if userOptions.device == "pc" then "workspace 1 output DP-2\nworkspace 2 output HDMI-1\nworkspace 3 output HDMI-1" else null;
    };
  };

  services.dunst = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    configFile = ./configs/hypr/dunst;
  };

  services.polybar = lib.attrsets.optionalAttrs (userOptions.wm == "i3") {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      pulseSupport = true;
    };
    settings = (import ./configs/i3/polybar/polybar.nix) { inherit userOptions; };
    script = ":";
  };

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

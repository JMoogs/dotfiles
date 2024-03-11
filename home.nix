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
    # Notifications
    (lib.mkIf (userOptions.wm == "hyprland") dunst)
    # Other
    (lib.mkIf (userOptions.wm == "hyprland") qt6.qtwayland)
    (lib.mkIf (userOptions.wm == "hyprland") libsForQt5.qt5.qtwayland)
    (lib.mkIf (userOptions.wm == "hyprland") wofi)
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
    (lib.mkIf (userOptions.wm != "hyprland") xclip)
    (lib.mkIf (userOptions.wm == "hyprland") wl-clipboard)
    killall
    # System monitor
    bottom

    # Notes
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
    # Use 2 clients for hyprland, as a workaround to screen flickering in XWayland, and keybinds not working in Wayland. One client for text and one for voice with PTT/toggle mute/toggle deafen
    (lib.mkIf (userOptions.wm == "hyprland") (discord-ptb.override {
      withOpenASAR = true;
      withVencord = true;
    }))
    
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
    (lib.mkIf (userOptions.wm != "hyprland") flameshot)
    (lib.mkIf (userOptions.wm == "hyprland") grimblast)

    # Wallpaper
    (lib.mkIf (userOptions.wm == "i3") feh)
    font-awesome
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
  programs.rofi = lib.attrsets.optionalAttrs (userOptions.wm == "i3") {
    enable = true;
    theme = ./configs/i3/rofiTheme.rasi;
  };
  programs.waybar = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    settings = (import ./configs/hypr/waybar.nix) { inherit userOptions; };
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

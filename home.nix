{pkgs, lib, userOptions, ...}:

{

  home.sessionPath = [ "$HOME/Documents/Apps" ];
  home.packages = with pkgs; [
    # Browser
    firefox

    # Terminal Setup
    tmux
    alacritty
    (lib.mkIf (userOptions.wm == "plasma") libsForQt5.yakuake)

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
    xclip
    killall
    # System monitor
    bottom

    # Notes
    obsidian
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
    flameshot
    # Wallpaper
    (lib.mkIf (userOptions.wm == "i3") feh)
    font-awesome
    # Sound controls
    pavucontrol
    libpulseaudio
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
    config = ./configs/i3/polybar/config;
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

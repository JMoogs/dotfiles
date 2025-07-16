{
  pkgs,
  lib,
  userOptions,
  inputs,
  config,
  ...
}: let
  themes = import ./home/theming/getTheme.nix {
    inherit pkgs config;
  };
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.nixcord.homeModules.nixcord
    # Shell
    ./home/shell
    # Fastfetch
    ./home/fastfetch.nix
    # Git settings
    ./home/git.nix
    # Neovim config
    ./home/neovim.nix
    # Media related programs/libraries (ffmpeg, mpv, etc.)
    ./home/media.nix
    # Utilities
    ./home/utilities.nix
    # Hyprland config
    ./home/hypr
    # General WM config
    ./home/wm
    # Theming options
    ./home/theming/theming.nix
    # Firefox - Currently testing brave
    ./home/firefox.nix
    # Brave
    ./home/chromium.nix
    # Discord + Vencord
    ./home/discord.nix
  ];

  themingModule.theme = lib.mkDefault "frappe";

  home.sessionVariables = {
    CONFIG_THEME = themes.name;
  };

  # Any extra programs I want in my path can be added to this folder:
  home.sessionPath = ["$HOME/Documents/Apps"];
  home.packages = with pkgs;
    [
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
      # Note taking
      anki # Flashcards
      typst # A program for writing and formatting scientific documents
      obsidian # Markdown notes
      gimp # Editing
      inkscape # Vector editing
      # ----------------------------- Discord
      # (discord.override {
      #   # Currently disabled as it has a bug preventing Discord activities from working
      #   # withOpenASAR = true; # A mod that rewrites part of Discord's code, making it faster: https://openasar.dev/
      #   withVencord = true; # A mod that allows for extra features including themes and plugins: https://vencord.dev/
      # })
      # vesktop # An alternative electron wrapper for Discord with Vencord built in: it allows for screensharing on Wayland
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
      hyprpaper # Set wallpapers
      hyprshade # Blue light filter and other shaders
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
    ];

  # Theme for GTK apps
  gtk = let
    useDark =
      if themes.name == "latte"
      then "false"
      else "true";
  in {
    enable = true;
    theme = themes.gtkTheme;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = useDark;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = useDark;
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      icon-theme = "Papirus";
      color-scheme =
        if themes.name == "latte"
        then "prefer-light"
        else "prefer-dark";
    };
  };

  xdg.configFile = let
    gtk4Dir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0";
  in {
    "gtk-4.0/assets".source = "${gtk4Dir}/assets";
    "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
  };

  # Audio effects
  services.easyeffects.enable = true;

  # Gpg
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  # DO NOT CHANGE - Supposed to stay at the original install version
  home.stateVersion = "23.05";
}

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
      # Note taking
      anki # Flashcards
      typst # A program for writing and formatting scientific documents
      obsidian # Markdown notes
      gimp # Editing
      inkscape # Vector editing
      # ----------------------------- Discord
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
  gtk = {
    enable = true;
    theme = themes.gtkTheme;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
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

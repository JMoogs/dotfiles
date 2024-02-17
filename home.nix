{pkgs, ...}:

{

  home.sessionPath = [ "$HOME/Documents/Apps" ];
  home.packages = [
    # Browser
    pkgs.firefox

    # Terminal Setup
    pkgs.tmux
    pkgs.alacritty
    pkgs.libsForQt5.yakuake

    # Developing
    # Editor
    pkgs.helix
    # For system clipboard working with helix
    pkgs.xclip
    pkgs.git
    pkgs.lazygit
    # Lsps
    pkgs.nil
    pkgs.haskellPackages.haskell-language-server
    pkgs.marksman
    # Rust
    pkgs.rustup
    # Haskell
    pkgs.ghc
    # Other utilities
    pkgs.ripgrep

    # Note taking
    pkgs.obsidian
    pkgs.wiki-tui
    pkgs.xf86_input_wacom
    pkgs.wacomtablet
    pkgs.xournal
    # Teams + Onenote + libreoffice
    # Microsoft stopped supporting the official teams client so had to swap.
    pkgs.teams-for-linux
    pkgs.p3x-onenote
    pkgs.libreoffice-qt

    # Discord with vencord
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    })

    # Recording
    pkgs.obs-studio
    # Games
    pkgs.steam
    pkgs.prismlauncher
    pkgs.wineWowPackages.stable

    # Vpn + Torrent
    pkgs.mullvad-vpn


  ];

  programs.alacritty = import ./configs/alacritty.nix;
  programs.helix = import ./configs/editor.nix;
  programs.tmux = (import ./configs/tmux.nix) { inherit pkgs; };
  programs.git = import ./configs/git.nix;
  programs.fish = import ./configs/fish.nix;

  # DO NOT CHANGE - Supposed to stay at the original install version 
  home.stateVersion = "23.05";
}

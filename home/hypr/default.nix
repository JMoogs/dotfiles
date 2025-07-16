{
  lib,
  userOptions,
  config,
  pkgs,
  ...
}: let
  themes = import ../theming/getTheme.nix {
    inherit config pkgs;
  };
in {
  home.packages = with pkgs; [
    hyprpaper # Set wallpapers
    hyprshade # Blue light filter and other shaders
  ];

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false; # Using UWSM
    settings = (import ./hyprland.nix) {
      inherit lib;
      inherit userOptions;
    };
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
    # portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Lock screen
  programs.hyprlock =
    import ./hyprlock.nix {inherit themes;};

  # Idle manager
  services.hypridle = import ./hypridle.nix {
    inherit userOptions;
    inherit lib;
  };
}

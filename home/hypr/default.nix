{
  lib,
  userOptions,
  inputs,
  pkgs,
  ...
}: let
  themes = import ../theming/theme.nix {
    inherit userOptions;
    inherit pkgs;
  };
in {
  home.packages = with pkgs; [
    hyprpaper # Set wallpapers
    hyprshade # Blue light filter and other shaders
  ];

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = (import ./hyprland.nix) {
      inherit lib;
      inherit userOptions;
    };
    package = inputs.hyprland.packages.${pkgs.system}.hyprland; # Uses master
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
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

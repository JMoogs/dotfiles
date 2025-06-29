{...}: {
  imports = [
    ./fish.nix
    ./kitty.nix
    ./zellij.nix
  ];

  # Direnv to automatically enter nix shells
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}

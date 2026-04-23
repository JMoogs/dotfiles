{...}: {
  # Firefox is installed but unconfigured — used as a fallback browser and PDF viewer.
  # Brave (chromium.nix) is the primary browser.
  programs.firefox.enable = true;
}

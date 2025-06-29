{...}: {
  # Jellyfin setup

  # Jellyfin itself
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "jeremy";
  };

  # Sonarr (TV shows)
  services.sonarr = {
    enable = true;
    openFirewall = true;
    user = "jeremy";
  };

  # Bazarr (subs)
  services.bazarr = {
    enable = true;
    openFirewall = true;
    user = "jeremy";
  };
}

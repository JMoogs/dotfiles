{
  pkgs,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;

    # languagePacks = [
    #   "en-GB"
    #   "ja"
    # ];
    #
    # profiles = {
    #   default = {
    #     isDefault = true;
    #     settings = {
    #       browser.newtabpage.enabled = false;
    #       browser.send_pings = false;
    #       browser.startup_page = 3; # Resume previous session
    #       browser.urlbar.placeholdername = "DuckDuckGo";
    #       layout.css.prefers-color-scheme.content-override = 2; # Use system theme
    #       media.ffmpeg.vaapi.enabled = true;
    #       privacy.donottrackheader.enabled = true;
    #       privacy.donottrackheader.value = 1;
    #
    #       # Fully disable Pocket. See
    #       # https://www.reddit.com/r/linux/comments/zabm2a.
    #       "extensions.pocket.enabled" = false;
    #       "extensions.pocket.api" = "0.0.0.0";
    #       "extensions.pocket.loggedOutVariant" = "";
    #       "extensions.pocket.oAuthConsumerKey" = "";
    #       "extensions.pocket.onSaveRecs" = false;
    #       "extensions.pocket.onSaveRecs.locales" = "";
    #       "extensions.pocket.showHome" = false;
    #       "extensions.pocket.site" = "0.0.0.0";
    #       "extensions.autoDisableScopes" = 0;
    #       "browser.newtabpage.activity-stream.pocketCta" = "";
    #       "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
    #       "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includePocket" =
    #         false;
    #     };
    #
    #     extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
    #       yomitan
    #       bitwarden
    #       ctrl-number-to-switch-tabs
    #       darkreader
    #       decentraleyes
    #       enhancer-for-youtube
    #       nighttab
    #       sponsorblock
    #       the-camelizer-price-history-ch
    #       ublock-origin
    #       user-agent-string-switcher
    #       vimium
    #       youtube-nonstop
    #     ];
    #   };
    # };
    #
    # # https://mozilla.github.io/policy-templates/
    # policies = {
    #   DisableTelemetry = true;
    #   HardwareAcceleration = true;
    #   SearchEngines = {
    #     "Default" = "DuckDeckGo";
    #   };
    #   SkipTermsOfUse = true;
    #   DontCheckDefaultBrowser = true;
    #   EnableTrackingProtection = {
    #     Value = true;
    #     Locked = true;
    #     Cryptomining = true;
    #     # Breaks some sites
    #     Fingerprinting = false;
    #   };
    #   DisableFirefoxScreenshots = true;
    #   DisableFirefoxStudies = true;
    #   OverrideFirstRunPage = "";
    #   OverridePostUpdatePage = "";
    # };
  };
}

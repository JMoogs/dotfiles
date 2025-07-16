# nix run github:KaylorBen/nixcord#docs
{
  pkgs,
  config,
  ...
}: let
  themes = import ./theming/getTheme.nix {inherit pkgs config;};
in {
  programs.nixcord = {
    enable = true;
    vesktop.enable = true;

    config = {
      enableReactDevtools = false;
      enabledThemes = []; # Look into this if it can be set declaratively
      themeLinks = themes.vencordTheme;
      transparent = true;

      plugins = {
        # All the API plugins are enabled by default it seems
        noTrack = {
          enable = true;
          disableAnalytics = true;
        };
        settings = {
          enable = true;
          settingsLocation = "aboveActivity";
        };
        alwaysTrust.enable = true;
        anonymiseFileNames = {
          enable = true;
          anonymiseByDefault = true;
        };
        blurNSFW.enable = true;
        clearURLs.enable = true;
        experiments.enable = true;
        fakeNitro.enable = true;
        forceOwnerCrown.enable = true;
        friendInvites.enable = true;
        iLoveSpam.enable = true;
        memberCount.enable = true;
        messageClickActions = {
          enable = true;
          enableDeleteOnClick = false;
          enableDoubleClickToEdit = true;
          enableDoubleClickToReply = true;
        };
        messageLogger = {
          enable = true;
          deleteStyle = "overlay";
          ignoreBots = false;
          ignoreSelf = true;
          logDeletes = true;
          logEdits = true;
          collapseDeleted = true;
          inlineEdits = true;
        };
        moreUserTags = {
          enable = true;
        };
        mutualGroupDMs.enable = true;
        noF1.enable = true;
        noReplyMention.enable = true;
        permissionsViewer.enable = true;
        platformIndicators.enable = true;
        sendTimestamps = {
          enable = true;
          replaceMessageContents = true;
        };
        shikiCodeblocks.enable = true;
        showHiddenChannels.enable = true;
        silentTyping = {
          enable = true;
          contextMenu = true;
          isEnabled = true;
          showIcon = true;
        };
        validUser.enable = true;
        volumeBooster = {
          enable = true;
          multiplier = 5;
        };
        normalizeMessageLinks.enable = true;
        fixYoutubeEmbeds.enable = true;
        friendsSince.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };
}

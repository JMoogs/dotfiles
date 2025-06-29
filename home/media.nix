{pkgs, ...}: {
  home.packages = with pkgs; [
    yt-dlp # Youtube downloader
    ffmpeg # Media processing
    pulseaudio # Required for waybar muting
    pavucontrol # Sound controls
    playerctl # Playing media controls
    youtube-music # Youtube music client
  ];

  # Mpv (media player) with mpris support among other things
  programs.mpv = {
    enable = true;
    scripts = with pkgs; [
      mpvScripts.mpris # Mpris support to control media with playerctl and to display media in taskbar
      mpvScripts.sponsorblock # Sponsorblock
      mpvScripts.youtube-upnext # Shows youtube's recommended videos when playing a video through mpv
      mpvScripts.mpv-cheatsheet # Shows keybinds
      mpvScripts.uosc # Alternate UI
      (mpvScripts.quality-menu.override {oscSupport = true;}) # Adds a quality menu to MPV when playing youtube videos
    ];
    config = {osd-font-size = 10;};
    # Add bindings to change video and audio quality when playing from youtube
    extraInput = ''
      Alt+f script-binding quality_menu/video_formats_toggle #! Stream Quality > Video
      Alt+g script-binding quality_menu/audio_formats_toggle #! Stream Quality > Audio
    '';
  };
}

{pkgs, ...}:
{
  enable = true;
  plugins = with pkgs.tmuxPlugins; [
    sensible
    {
      plugin = dracula;
      extraConfig = ''
        set -g @dracula-plugins "cpu-usage gpu-usage ram-usage network-ping time"
        set -g @dracula-ping-server "8.8.8.8"
        set -g @dracula-day-month true
        set -g @dracula-military-time true
      '';
    }
  ];

  extraConfig = ''
      set -g default-terminal "alacritty"
      # Makes colours inside tmux match outside tmux
      # https://unix.stackexchange.com/questions/348771/why-do-vim-colors-look-different-inside-and-outside-of-tmux
      set-option -ga terminal-overrides ",alacritty:Tc"
  '';
}
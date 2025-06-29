{
  userOptions,
  pkgs,
  ...
}: let
  themes = import ../theming/theme.nix {
    inherit userOptions;
    inherit pkgs;
  };
in {
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
    settings = {
      # Options can be found here:
      # https://zellij.dev/documentation/options

      # Options are quit/detatch
      on_force_close = "quit";

      # We have nerdfonts installed so we can use the full ui
      simplified_ui = false;

      # Defaults to $SHELL so don't bind
      # default_shell = "fish";

      pane_frames = false;

      theme_dir = "/etc/nixos/home/theming/zellij";

      theme = "dracula_modified";

      # Maybe swap after learning the binds?
      # default_layout = "compact";

      # Start in locked mode so zellij features are only on activation
      default_mode = "locked";

      scroll_buffer_size = 15000;

      copy_command = "wl-copy";

      # Maybe it's a good setting, leave it on for now.
      # copy_on_select = false;

      ui.pane_frames.hide_session_name = true;

      # Use the yaml format as kdl isn't supported yet:
      # https://zellij.dev/old-documentation/keybindings
      # keybinds = {
      #   unbind = true;
      # };
    };
  };
}

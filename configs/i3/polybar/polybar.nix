# services.polybar.config	Polybar configuration. Can be either path to a file, or set of attributesthat will be used to create the final configuration.See also services.polybar.settings for a more nix-friendly format.	(attribute set of attribute set of (string or boolean or signed integer or list of string)) or path convertible to it
# services.polybar.enable	Whether to enable Polybar status bar.	boolean
# services.polybar.extraConfig	Additional configuration to add.	strings concatenated with “\n”
# services.polybar.package	Polybar package to install.	package
# services.polybar.script	This script will be used to start the polybars.Set all necessary environment variables here and start all bars.It can be assumed that polybar executable is in the PATH.	strings concatenated with “\n”
# services.polybar.settings	Polybar configuration. This takes a nix attrset and converts it to thestrange data format that polybar uses.Each entry will be converted to a section in the output file.Several things are treated specially: nested keys are convertedto dash-separated keys; the special text key is ignored as a nested key,to allow mixing different levels of nesting; and lists are converted topolybar’s foo-0, foo-1, ... format.	attribute set of attribute sets
{userOptions, ...}:
{
  colors = {
      background = "#282a36";
      background-alt = "#44475a";
      foreground = "#f8f8f2";
      primary = "#bd93f9";
      secondary = "#ffb86c";
      alert = "#ff5555";
      disabled = "#6272a4";
  };

  "bar/desktop" = {
    monitor = "\${env:MONITOR:}";
    width = "100%";
    height = "24pt";

    background = "\${colors.background}";
    foreground = "\${colors.foreground}";

    line-size = "3pt";

    padding-left = 2;
    padding-right = 1;

    module-margin = 1;

    seperator = "|";
    seperator-foreground = "\${colors.disabled}";

    font-0 = "Fira Code;style=bold;2";
    font-1 = "Font Awesome 6 Free:pixelsize=12;2";
    font-2 = "Font Awesome 6 Free Solid:pixelsize=12;2";
    font-3 = "Font Awesome 6 Brands:pixelsize=12;2";
    font-4 = "monospace;2";

    modules-left = "i3";
    modules-center = "playerctl date time";
    modules-right = if (userOptions.nvidia && userOptions.device == "pc") then "pulseaudio memory cpu gpu temperature filesystem powermenu" else "pulseaudio memory cpu temperature filesystem wlan battery powermenu";

    cursor-click = "pointer";
    cursor-scroll = "ns-resize";

    enable-ipc = true;

    override-redirect = false;
  };

  "module/xworkspaces" = {
    
    type = "internal/xworkspaces";

    label-active = "%name%";
    label-active-background = "\${colors.background-alt}";
    label-active-underline= "\${colors.primary}";
    label-active-padding = 1;

    label-occupied = "%name%";
    label-occupied-padding = 1;

    label-urgent = "%name%";
    label-urgent-background = "\${colors.alert}";
    label-urgent-padding = 1;

    label-empty = "%name%";
    label-empty-foreground = "\${colors.disabled}";
    label-empty-padding = 1;
  };

  "module/i3" = {
    
    type="internal/i3";

    index-sort = true;
    strip-wsnumbers = true;

    label-focused = "%icon% %name%";
    label-focused-background = "\${colors.background-alt}";
    label-focused-underline= "\${colors.secondary}";
    label-focused-padding = 1;

    label-unfocused = "%icon% %name%";
    label-unfocused-padding = 1;

    label-urgent = "%icon% %name%";
    label-urgent-background = "\${colors.alert}";
    label-urgent-padding = 1;

    label-visible = "%icon% %name%";
    label-visible-foreground = "\${colors.disabled}";
    label-visible-padding = 1;

    ws-icon-default = "";
    ws-icon-0 = "1;";
    ws-icon-1 = "2;";
    ws-icon-2 = "3;";

    format = "<label-state>";
  };

  "module/filesystem" = {
    type = "internal/fs";
    interval = 25;

    mount-0 = "/";
    format-mounted = "<label-mounted>";
    format-mounted-prefix = " ";
    format-mounted-prefix-foreground = "\${colors.primary}";
    label-mounted =  "%percentage_used%%";

    label-unmounted = "%mountpoint% not mounted";
    label-unmounted-foreground = "\${colors.disabled}";
  };

  "module/pulseaudio" = {

    type = "internal/pulseaudio";

    sink = "alsa_output.pci-0000_12_00.3.analog-stereo";

    format-volume = "  <ramp-volume>  <label-volume>";
    format-muted = " Muted";
    format-muted-foreground = "\${colors.disabled}";
    ramp-volume-0 = "";
    ramp-volume-1 = "";
    ramp-volume-2 = "";
    ramp-volume-foreground = "\${colors.primary}";

    # Open volume mixer on right click
    click-right = "pgrep pavucontrol | xargs kill || pavucontrol &> /dev/null";
  };

  "module/memory" = {
    type = "internal/memory";
    interval = 2;
    format-prefix = " ";
    format-prefix-foreground = "\${colors.primary}";
    label = "%percentage_used:2%%";
  };

  "module/gpu" = {
    type = "custom/script";
    exec = "echo $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)%";
    interval = 5;
    format-prefix = " ";
    format-prefix-foreground = "\${colors.primary}";
  };

  "module/wlan" = {
    type = "internal/network";
    interface = "wlo1";
    interface-type = "wireless";
    interval = 3.0;

    format-connected = "<label-connected>";
    format-connected-prefix = "  ";
    format-connected-prefix-foreground = "\${colors.primary}";
    label-connected = "%essid%%downspeed:9% ";
    label-connected-maxlen = 25;

    format-disconnected = "<label-disconnected>";
    format-disconnected-underline = "\${colors.alert}";
    format-disconnected-prefix = "  ";
    format-disconnected-prefix-foreground = "\${colors.alert}";
    label-disconnected = "%ifname%";

    ramp-signal-0 = "▁";
    ramp-signal-1 = "▂";
    ramp-signal-2 = "▃";
    ramp-signal-3 = "▄";
    ramp-signal-4 = "▅";
    ramp-signal-5 = "▆";
    ramp-signal-6 = "▇";
    ramp-signal-7 = "█";

    ramp-signal-foreground = "\${colors.primary}";
    ramp-signal-font-format = 4;
  };

  "module/date" = {
    type = "internal/date";
    interval = 1;

    date = "%a %b %d %Y";

    label = "%date%";
    format-prefix = "  " ;
    format-prefix-foreground = "\${colors.primary}";
  };

  "module/time" = {
    type = "internal/date";
    interval = 1;
    date = "%H:%M";

    label = "%date%";
    format-prefix = " ";
    format-prefix-foreground = "\${colors.primary}";
  };

  "module/battery" = {
    type = "internal/battery";
    battery = "BAT0";
    adapter = "ADP1";

    full-at = 99;
    format-charging = "<label-charging>";
    format-charging-prefix = " ";
    format-charging-prefix-foreground = "\${colors.primary}";
    label-charging = "%percentage%%";
    format-discharging = "<ramp-capacity> <label-discharging>";
    label-discharging = "%percentage%%";
    format-full = "<ramp-capacity> 100%";

    ramp-capacity-0 = "";
    ramp-capacity-1 = "";
    ramp-capacity-2 = "";
    ramp-capacity-3 = "";
    ramp-capacity-4 = "";
    ramp-capacity-foreground = "\${colors.primary}";
  };

  "module/powermenu" = {

    type = "custom/menu";

    expand-right = true;

    format-spacing = 1;

    label-open = "";
    label-open-foreground = "\${colors.primary}";
    label-close = "";
    label-close-foreground = "\${colors.primary}";
    label-separator = " ";

    menu-0-0 = "";
    menu-0-0-exec = "menu-open-1";
    menu-0-1 = "";
    menu-0-1-exec = "menu-open-2";

    menu-1-0 = "";
    menu-1-0-exec = "menu-open-0";
    menu-1-1 = "";
    menu-1-_1-exec = "reboot";

    menu-2-0 = "";
    menu-2-0-exec = "shutdown now";
    menu-2-1 = "";
    menu-2-1-exec = "menu-open-0";

  };

  "module/temperature" = {
    type = "internal/temperature";

    format = "<ramp> <label>";
    label = "%temperature-c%";

    ramp-0 = "";
    ramp-1 = "";
    ramp-2 = "";
    ramp-3 = "";
    ramp-4 = "";
    ramp-foreground = "\${colors.primary}";
  };

  "settings" = {
    screenchange-reload = true;
    pseudo-transparency = true;
  };

  "module/playerctl" = {
    type = "custom/script";
    format-prefix = " ";
    format-prefix-foreground = "\${colors.primary}";
    tail = true;
    exec = "stdbuf -o0 playerctl metadata -Ff '{{trunc(title,70)}} %{A1:playerctl previous:}%{A} %{A1:playerctl play-pause:}<<{{uc(status)}}>>%{A} %{A1:playerctl next:}%{A}' | stdbuf -i0 -o0 sed -e 's/<<PLAYING>>//' -e 's/<<PAUSED>>//'";
    exec-if = "playerctl metadata -f {{playerName}} 2>/dev/null | grep -v mopidy >/dev/null";
  };
}


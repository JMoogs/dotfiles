{lib, userOptions, ...}:

{
  enable = false;

  settings = {
    lockCmd = "pidof hyprlock | hyprlock";

    listener = [
      {
        timeout = if userOptions.device == "laptop" then 120 else 600;
        on-timeout = "loginctl lock-session";
      }
    
    ] ++ lib.optionals (userOptions.device == "laptop") [
      {
        timeout = 180;
        on-timeout = "systemctl suspend";
      }
    ];
  };
}

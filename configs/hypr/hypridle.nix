{lib, userOptions, ...}:

{
  enable = true;

  lockCmd = "pidof hyprlock | hyprlock";

  listeners = [
    {
      timeout = 150;
      onTimeout = "loginctl lock-session";
    }
    
  ] ++ lib.optionals (userOptions.device == "laptop") [
    {
      timeout = 180;
      onTimeout = "systemctl suspend";
    }
  ];
}

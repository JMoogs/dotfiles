{lib, userOptions, ...}:

{
  enable = true;

  lockCmd = "pidof hyprlock | hyprlock";

  listeners = [
    {
      timeout = 300;
      onTimeout = "loginctl lock-session";
    }
    
  ] ++ lib.optionals (userOptions.device == "laptop") [
    {
      timeout = 330;
      onTimeout = "systemctl suspend";
    }
  ];
}
